import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magadige/models/app.notification.model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a notification
  Future<void> createNotification(AppNotification notification) async {
    await _firestore.collection('notifications').add(notification.toMap());
  }

  // Get a stream of notifications
  Stream<List<AppNotification>> getNotifications() {
    return _firestore.collection('notifications').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return AppNotification.fromMap(
            doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Update a notification
  Future<void> updateNotification(
      String id, AppNotification updatedNotification) async {
    await _firestore
        .collection('notifications')
        .doc(id)
        .update(updatedNotification.toMap());
  }

  // Delete a notification
  Future<void> deleteNotification(String id) async {
    await _firestore.collection('notifications').doc(id).delete();
  }
}
