import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyContact {
  final String id;
  final String userId;
  final String name;
  final String contact;
  final String? imageUrl;

  EmergencyContact({
    required this.id,
    required this.userId,
    required this.name,
    required this.contact,
    this.imageUrl,
  });

  factory EmergencyContact.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return EmergencyContact(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      contact: data['contact'] ?? '',
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'contact': contact,
      'imageUrl': imageUrl,
    };
  }
}
