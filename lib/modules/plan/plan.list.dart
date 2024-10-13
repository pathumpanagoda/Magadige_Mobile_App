import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:magadige/models/travel.location.model.dart';
import 'package:magadige/models/travel.plan.dart'; // Assuming this is the location of your service file
import 'package:magadige/modules/plan/create.plan.view.dart';
import 'package:magadige/modules/plan/single.plan.view.dart';
import 'package:magadige/utils/index.dart';

class PlanList extends StatelessWidget {
  const PlanList({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Trips",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // StreamBuilder to display trips
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('travelPlans')
                    .where('userId', isEqualTo: userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading trips'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No trips found.'));
                  }

                  final travelPlans = snapshot.data!.docs
                      .map((doc) => TravelPlan.fromDocumentSnapshot(doc))
                      .toList();

                  return ListView.builder(
                    itemCount: travelPlans.length,
                    itemBuilder: (context, index) {
                      final plan = travelPlans[index];
                      return _buildTripCard(plan, context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.navigator(context, const CreatePlanView());
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Helper method to build trip cards following the design
  Widget _buildTripCard(TravelPlan plan, BuildContext context) {
    // Safely find the first location from dummyLocations based on locationId
    TravelLocation? firstLocation = dummyLocations.firstWhere(
      (element) => element.id == plan.locationIds.first,
    );

    return InkWell(
      onTap: () {
        context.navigator(context, SinglePlanView(plan: plan));
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Image placeholder, handle null safety for firstLocation and imageUrl
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: firstLocation != null &&
                          firstLocation.imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(firstLocation.imageUrl),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: AssetImage('assets/placeholder_image.png'),
                          fit: BoxFit.cover,
                        ), // Show a placeholder if imageUrl is null or empty
                ),
              ),
              const SizedBox(width: 16),

              // Trip information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstLocation?.name ?? 'Unknown Location',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Date: ${plan.startDate.toLocal()}'.split(' ')[0],
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    _getRelativeTime(plan.startDate),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getRelativeTime(DateTime startDate) {
    final now = DateTime.now();
    final difference = startDate.difference(now).inDays;

    String text = '';
    if (difference == 0) {
      text = 'Today';
    } else if (difference == 1) {
      text = 'Tomorrow';
    } else if (difference < 7) {
      text = 'This week';
    } else if (difference < 30) {
      text = 'Next week';
    } else {
      text = 'In ${difference ~/ 30} months';
    }

    return Text(
      text,
      style: const TextStyle(fontSize: 14, color: Colors.green),
    );
  }
}
