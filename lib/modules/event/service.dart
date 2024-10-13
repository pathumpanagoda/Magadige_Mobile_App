import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magadige/models/app.notification.model.dart';
import 'package:magadige/models/event.model.dart';
import 'package:magadige/modules/notifications/servie.dart';

class EventService {
  final CollectionReference _eventCollection =
      FirebaseFirestore.instance.collection('events');
  final _notificationService = NotificationService();
  // Create event
  Future<void> createEvent(Event event) async {
    await _eventCollection.add(event.toMap());
    AppNotification notification = AppNotification(
        id: "",
        title: "New event has created",
        subtitle: "${event.name} is their, Join and have fun",
        dateCreated: DateTime.now());
    await _notificationService.createNotification(notification);
  }

  // Read all events
  Stream<List<Event>> getEvents() {
    return _eventCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Event.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Update event
  Future<void> updateEvent(Event event) async {
    await _eventCollection.doc(event.id).update(event.toMap());
  }

  // Delete event
  Future<void> deleteEvent(String eventId) async {
    await _eventCollection.doc(eventId).delete();
  }
}
