import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String id;
  String userId;
  String locationId;
  String review;
  int numStars;

  Review({
    required this.id,
    required this.userId,
    required this.locationId,
    required this.review,
    required this.numStars,
  });

  // Convert Review object to map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'locationId': locationId,
      'review': review,
      'numStars': numStars,
    };
  }

  // Create a Review object from Firestore map
  factory Review.fromMap(String id, Map<String, dynamic> map) {
    return Review(
      id: id,
      userId: map['userId'] ?? '',
      locationId: map['locationId'] ?? '',
      review: map['review'] ?? '',
      numStars: map['numStars'] ?? 0,
    );
  }

  // Create a Review object from Firestore DocumentSnapshot
  factory Review.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Review(
      id: doc.id,
      userId: data['userId'] ?? '',
      locationId: data['locationId'] ?? '',
      review: data['review'] ?? '',
      numStars: data['numStars'] ?? 0,
    );
  }
}
