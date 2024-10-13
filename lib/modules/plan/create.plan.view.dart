import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:magadige/models/travel.location.model.dart';
import 'package:magadige/models/travel.plan.dart';
import 'package:magadige/modules/plan/service.dart';

import 'package:magadige/widgets/custom.filled.button.dart';

class CreatePlanView extends StatefulWidget {
  const CreatePlanView({super.key});

  @override
  _CreatePlanViewState createState() => _CreatePlanViewState();
}

class _CreatePlanViewState extends State<CreatePlanView> {
  final List<TravelLocation> availableLocations = dummyLocations;
  final List<String> selectedLocations = [];
  bool loading = false;
  DateTime? startDate;
  DateTime? endDate;
  final TravelPlanService travelPlanService = TravelPlanService();

  // Method to show date picker
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
        } else {
          endDate = pickedDate;
        }
      });
    }
  }

  // Method to select location from the available ones
  void _selectLocation() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: availableLocations.map((location) {
            return ListTile(
              title: Text(location.name),
              onTap: () {
                Navigator.pop(context, location.id);
              },
            );
          }).toList(),
        );
      },
    );

    if (result != null && !selectedLocations.contains(result)) {
      setState(() {
        selectedLocations.add(result);
      });
    }
  }

  // Method to create and save the travel plan
  Future<void> _createTravelPlan() async {
    if (startDate == null || endDate == null || selectedLocations.isEmpty) {
      // Show error or warning if necessary data is missing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final travelPlan = TravelPlan(
        id: '',
        userId: user.uid,
        locationIds: selectedLocations,
        startDate: startDate!,
        endDate: endDate!,
        createdDate: DateTime.now(),
      );
      setState(() {
        loading = true;
      });
      await travelPlanService.createTravelPlan(travelPlan);
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Travel plan created successfully!')),
      );
    } else {
      // Handle case where user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan a Trip', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Location', style: TextStyle(fontSize: 16)),
            ...selectedLocations.map((locationId) {
              final location =
                  availableLocations.firstWhere((loc) => loc.id == locationId);
              return ListTile(
                leading: const Icon(Icons.location_on, color: Colors.green),
                title: Text(location.name),
              );
            }),
            CustomButton(
              onPressed: () {
                _selectLocation();
              },
              text: "Add New Location",
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _selectDate(context, true),
                  child: Text(
                    startDate != null
                        ? DateFormat('dd MMM').format(startDate!)
                        : 'Start Date',
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
                TextButton(
                  onPressed: () => _selectDate(context, false),
                  child: Text(
                    endDate != null
                        ? DateFormat('dd MMM').format(endDate!)
                        : 'End Date',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: CustomButton(
                loading: loading,
                onPressed: _createTravelPlan,
                text: "Continue",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
