import 'package:flutter/material.dart';
import 'package:magadige/constants.dart';
import 'package:magadige/models/travel.location.model.dart';
import 'package:magadige/modules/home/location.card.dart';
import 'package:magadige/modules/home/travel.location.service.dart';
import 'package:magadige/modules/plan/create.plan.view.dart';
import 'package:magadige/utils/index.dart';

class AllLocationsView extends StatelessWidget {
  const AllLocationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Locations",
          style: TextStyle(
            color: titleGrey,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          context.navigator(context, const CreatePlanView());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<List<TravelLocation>>(
        stream: TravelLocationService().getTravelLocations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No locations available'));
          }

          final locations = snapshot.data!;

          return ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              return HanthanaMountainCard(
                location: locations[index],
              );
            },
          );
        },
      ),
    );
  }
}
