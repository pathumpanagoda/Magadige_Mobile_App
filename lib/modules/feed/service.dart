import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magadige/models/feed.model.dart';

class FeedService {
  final CollectionReference _feedCollection =
      FirebaseFirestore.instance.collection('feeds');
  Future<List<Feed>> getUserFeeds(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await _feedCollection.where('userId', isEqualTo: userId).get();

      return querySnapshot.docs.map((doc) => Feed.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting user feeds: $e');
      rethrow;
    }
  }

  // Create a new feed
  Future<void> createFeed(Feed feed) async {
    await _feedCollection.add(feed.toMap());
  }

  // Read all feeds
  Stream<List<Feed>> getAllFeeds() {
    return _feedCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Feed.fromFirestore(doc)).toList();
    });
  }

  // Read feeds by user ID
  Stream<List<Feed>> getFeedsByUserId(String userId) {
    return _feedCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Feed.fromFirestore(doc)).toList();
    });
  }

  // Read feeds by category
  Stream<List<Feed>> getFeedsByCategory(FeedCategory category) {
    return _feedCollection
        .where('category', isEqualTo: category.toString().split('.').last)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Feed.fromFirestore(doc)).toList();
    });
  }

  // Update a feed
  Future<void> updateFeed(String id, Feed feed) async {
    await _feedCollection.doc(id).update(feed.toMap());
  }

  // Delete a feed
  Future<void> deleteFeed(String id) async {
    await _feedCollection.doc(id).delete();
  }
}
