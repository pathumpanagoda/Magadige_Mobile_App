import 'package:cloud_firestore/cloud_firestore.dart';

class TravelPlan {
  final String id;
  final String userId;
  final List<String> locationIds;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdDate;

  TravelPlan({
    required this.id,
    required this.userId,
    required this.locationIds,
    required this.startDate,
    required this.endDate,
    required this.createdDate,
  });

  // Convert TravelPlan object to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'locationIds': locationIds,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
    };
  }

  // Convert Firestore document to TravelPlan object
  static TravelPlan fromDocumentSnapshot(DocumentSnapshot doc) {
    return TravelPlan(
      id: doc.id,
      userId: doc['userId'],
      locationIds: List<String>.from(doc['locationIds']),
      startDate: DateTime.parse(doc['startDate']),
      endDate: DateTime.parse(doc['endDate']),
      createdDate: DateTime.parse(doc['createdDate']),
    );
  }
}
