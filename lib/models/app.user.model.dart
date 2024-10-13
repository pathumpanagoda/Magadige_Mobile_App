import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String fullName;
  final String email;
  final String? imageUrl;
  final String? bio;

  AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    this.imageUrl,
    this.bio,
  });

  // Create an AppUser instance from a Firestore DocumentSnapshot
  factory AppUser.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return AppUser(
      id: doc.id,
      fullName: data?['fullName'] ?? '',
      email: data?['email'] ?? '',
      imageUrl: data?['imageUrl'],
      bio: data?['bio'],
    );
  }

  // Convert AppUser instance to a Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'imageUrl': imageUrl,
      'bio': bio,
    };
  }

  // Create a copy of AppUser with optional field updates
  AppUser copyWith({
    String? fullName,
    String? email,
    String? imageUrl,
    String? bio,
  }) {
    return AppUser(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      bio: bio ?? this.bio,
    );
  }

  @override
  String toString() {
    return 'AppUser(id: $id, fullName: $fullName, email: $email, imageUrl: $imageUrl, bio: $bio)';
  }
}
