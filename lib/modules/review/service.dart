import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magadige/models/review.model.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<Review>> getReviewsByLocation(String locationId) {
    return _firestore
        .collection('reviews')
        .where('locationId', isEqualTo: locationId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList());
  }

  // Collection reference for reviews
  CollectionReference get _reviewsCollection =>
      _firestore.collection('reviews');

  // Create a new review
  Future<void> createReview(Review review) async {
    await _reviewsCollection.add(review.toMap());
  }

  // Fetch all reviews for a location
  Future<List<Review>> getReviewsForLocation(String locationId) async {
    QuerySnapshot snapshot = await _reviewsCollection
        .where('locationId', isEqualTo: locationId)
        .get();

    return snapshot.docs.map((doc) {
      return Review.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // Fetch review by ID
  Future<Review?> getReviewById(String id) async {
    DocumentSnapshot doc = await _reviewsCollection.doc(id).get();

    if (doc.exists) {
      return Review.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  // Update a review
  Future<void> updateReview(String id, Review updatedReview) async {
    await _reviewsCollection.doc(id).update(updatedReview.toMap());
  }

  // Delete a review
  Future<void> deleteReview(String id) async {
    await _reviewsCollection.doc(id).delete();
  }
}
