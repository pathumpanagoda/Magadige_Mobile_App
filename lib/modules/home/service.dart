import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:magadige/models/travel.location.model.dart';

class TravelLocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveLocation(TravelLocation location) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('saved_locations')
          .doc(location.id)
          .set(location.toMap());
    }
  }

  Future<void> unsaveLocation(String locationId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('saved_locations')
          .doc(locationId)
          .delete();
    }
  }

  Future<bool> isLocationSaved(String locationId) async {
    final user = _auth.currentUser;
    if (user != null) {
      final docSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('saved_locations')
          .doc(locationId)
          .get();
      return docSnapshot.exists;
    }
    return false;
  }

  Stream<List<TravelLocation>> getSavedLocations() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('saved_locations')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => TravelLocation.fromDocumentSnapshot(doc))
            .toList();
      });
    }
    return Stream.value([]);
  }
}
