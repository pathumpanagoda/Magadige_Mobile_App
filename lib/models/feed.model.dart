import 'package:cloud_firestore/cloud_firestore.dart';

enum FeedCategory {
  hotel,
  flight,
  bus,
  board,
}

class Feed {
  final String id;
  final String userId;
  final String? imageUrl;
  final String caption;
  final String location;
  final String category;

  Feed({
    required this.id,
    required this.userId,
    this.imageUrl,
    required this.caption,
    required this.category,
    required this.location,
  });

  factory Feed.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Feed(
      id: doc.id,
      userId: data['userId'] ?? '',
      imageUrl: data['imageUrl'],
      caption: data['caption'] ?? '',
      location: data['location'] ?? '',
      category: data['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'imageUrl': imageUrl,
      'caption': caption,
      'category': category.toString().split('.').last,
      'location': location,
    };
  }
}
