import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magadige/models/user.follow.model.dart';

class UserFollowService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'user_follows';

  // Create or update a UserFollow document
  Future<void> saveUserFollow(UserFollow userFollow) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(userFollow.userId)
          .set(userFollow.toMap());
    } catch (e) {
      print('Error saving user follow: $e');
      rethrow;
    }
  }

  // Get a UserFollow document by userId
  Future<UserFollow?> getUserFollow(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(_collectionName).doc(userId).get();
      if (doc.exists) {
        return UserFollow.fromDocumentSnapshot(doc);
      }
      return null;
    } catch (e) {
      print('Error getting user follow: $e');
      rethrow;
    }
  }

  // Add a follower to a user's follower list

  Future<void> addFollower(String userId, String followerId) async {
    try {
      final userDoc =
          await _firestore.collection(_collectionName).doc(userId).get();

      if (userDoc.exists) {
        // Document exists, update it
        await _firestore.collection(_collectionName).doc(userId).update({
          'followerIds': FieldValue.arrayUnion([followerId])
        });
      } else {
        // Document doesn't exist, create it
        await _firestore.collection(_collectionName).doc(userId).set({
          'followerIds': [followerId]
        });
      }
    } catch (e) {
      print('Error adding follower: $e');
      rethrow;
    }
  }

  // Remove a follower from a user's follower list
  Future<void> removeFollower(String userId, String followerId) async {
    try {
      await _firestore.collection(_collectionName).doc(userId).update({
        'followerIds': FieldValue.arrayRemove([followerId])
      });
    } catch (e) {
      print('Error removing follower: $e');
      rethrow;
    }
  }

  // Get the number of followers for a user
  Future<int> getFollowerCount(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(_collectionName).doc(userId).get();
      if (doc.exists) {
        UserFollow userFollow = UserFollow.fromDocumentSnapshot(doc);
        return userFollow.followerIds.length;
      }
      return 0;
    } catch (e) {
      print('Error getting follower count: $e');
      rethrow;
    }
  }

  // Check if a user is following another user
  Future<bool> isFollowing(String userId, String followerId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(_collectionName).doc(userId).get();
      if (doc.exists) {
        UserFollow userFollow = UserFollow.fromDocumentSnapshot(doc);
        return userFollow.followerIds.contains(followerId);
      }
      return false;
    } catch (e) {
      print('Error checking if following: $e');
      rethrow;
    }
  }

  // Get all followers for a user
  Future<List<String>> getFollowers(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(_collectionName).doc(userId).get();
      if (doc.exists) {
        UserFollow userFollow = UserFollow.fromDocumentSnapshot(doc);
        return userFollow.followerIds;
      }
      return [];
    } catch (e) {
      print('Error getting followers: $e');
      rethrow;
    }
  }
}
