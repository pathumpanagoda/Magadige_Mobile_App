import 'package:flutter/material.dart';
import 'package:magadige/models/travel.location.model.dart';
import 'package:magadige/models/travel.plan.dart';
import 'package:magadige/modules/friends/friend.list.dart';
import 'package:magadige/utils/index.dart';

class SinglePlanView extends StatelessWidget {
  final TravelPlan plan;
  const SinglePlanView({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(location(plan.locationIds.first)!.name),
              background: Image.network(
                location(plan.locationIds.first)!.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trip Title
                  Text(
                    location(plan.locationIds.first)!.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Trip Location
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        location(plan.locationIds.first)!
                            .address, // Replace with actual location
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Text(" -> "),
                      const Icon(Icons.location_on, color: Colors.green),
                      const SizedBox(width: 4),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    location(plan.locationIds.first)!
                        .description, // Replace with destination if different
                    style: const TextStyle(fontSize: 16),
                  ),

                  // Destinations List
                  const Text(
                    "Destinations",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: plan.locationIds.map((locationId) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: _buildDestinationCard(locationId),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'View On Map',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.navigator(context, const FriendList());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Invire friends',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Destination card widget
  Widget _buildDestinationCard(String locationId) {
    TravelLocation? loc = location(locationId);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Destination image
            Expanded(
              child: Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(loc!.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),

            // Destination name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${loc.name}', // Replace with actual location name
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TravelLocation? location(String id) {
    TravelLocation? firstLocation = dummyLocations.firstWhere(
      (element) => element.id == id,
    );
    return firstLocation;
  }
}
