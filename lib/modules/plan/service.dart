import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magadige/models/travel.plan.dart';

class TravelPlanService {
  final CollectionReference travelPlansCollection =
      FirebaseFirestore.instance.collection('travelPlans');

  // Create a new travel plan
  Future<void> createTravelPlan(TravelPlan plan) async {
    await travelPlansCollection.add(plan.toMap());
  }

  // Retrieve all travel plans for the current user
  Future<List<TravelPlan>> getUserTravelPlans(String userId) async {
    QuerySnapshot snapshot =
        await travelPlansCollection.where('userId', isEqualTo: userId).get();

    return snapshot.docs
        .map((doc) => TravelPlan.fromDocumentSnapshot(doc))
        .toList();
  }

  // Update an existing travel plan
  Future<void> updateTravelPlan(String id, TravelPlan updatedPlan) async {
    await travelPlansCollection.doc(id).update(updatedPlan.toMap());
  }

  // Delete a travel plan
  Future<void> deleteTravelPlan(String id) async {
    await travelPlansCollection.doc(id).delete();
  }
}
