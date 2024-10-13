import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magadige/models/travel.location.model.dart';

class TravelLocationService {
  final CollectionReference _locationsCollection =
      FirebaseFirestore.instance.collection('locations');

  // Create a new travel location
  Future<void> addTravelLocation(TravelLocation location) async {
    await _locationsCollection.add(location.toMap());
  }

  // Read all travel locations
  Stream<List<TravelLocation>> getTravelLocations() {
    return _locationsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TravelLocation.fromDocumentSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    });
  }

  // Read a single travel location by ID
  Future<TravelLocation?> getTravelLocationById(String id) async {
    DocumentSnapshot doc = await _locationsCollection.doc(id).get();
    if (doc.exists) {
      return TravelLocation.fromDocumentSnapshot(
          doc as DocumentSnapshot<Map<String, dynamic>>);
    }
    return null;
  }

  // Update a travel location
  Future<void> updateTravelLocation(TravelLocation location) async {
    await _locationsCollection.doc(location.id).update(location.toMap());
  }

  // Delete a travel location
  Future<void> deleteTravelLocation(String id) async {
    await _locationsCollection.doc(id).delete();
  }

  // Add dummy locations to Firestore
  Future<void> addDummyLocations() async {
    for (var location in dummyLocations) {
      await addTravelLocation(location);
    }
  }

  // Check if dummy data exists
  Future<bool> dummyDataExists() async {
    QuerySnapshot snapshot = await _locationsCollection.limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  // Initialize Firestore with dummy data if it's empty
  Future<void> initializeFirestore() async {
    bool exists = await dummyDataExists();
    if (!exists) {
      await addDummyLocations();
    }
  }
}
