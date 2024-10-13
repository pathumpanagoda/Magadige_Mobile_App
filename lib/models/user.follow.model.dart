import 'package:cloud_firestore/cloud_firestore.dart';

class UserFollow {
  final String userId;
  final List<String> followerIds;

  UserFollow({
    required this.userId,
    required this.followerIds,
  });

  // Create a UserFollow instance from a Firestore DocumentSnapshot
  factory UserFollow.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return UserFollow(
      userId: doc.id,
      followerIds: List<String>.from(data?['followerIds'] ?? []),
    );
  }

  // Convert UserFollow instance to a Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'followerIds': followerIds,
    };
  }

  // Create a copy of UserFollow with optional field updates
  UserFollow copyWith({
    String? userId,
    List<String>? followerIds,
  }) {
    return UserFollow(
      userId: userId ?? this.userId,
      followerIds: followerIds ?? this.followerIds,
    );
  }

  @override
  String toString() {
    return 'UserFollow(userId: $userId, followerIds: $followerIds)';
  }
}
