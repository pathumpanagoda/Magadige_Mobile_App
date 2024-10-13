import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magadige/models/emergency.contact.model.dart';

class EmergencyContactService {
  final CollectionReference _contactsCollection =
      FirebaseFirestore.instance.collection('emergencyContacts');

  Future<List<EmergencyContact>> getContacts(String userId) async {
    QuerySnapshot snapshot =
        await _contactsCollection.where('userId', isEqualTo: userId).get();
    return snapshot.docs
        .map((doc) => EmergencyContact.fromDocumentSnapshot(doc))
        .toList();
  }

  Future<void> addContact(EmergencyContact contact) async {
    await _contactsCollection.add(contact.toMap());
  }

  Future<void> updateContact(EmergencyContact contact) async {
    await _contactsCollection.doc(contact.id).update(contact.toMap());
  }

  Future<void> deleteContact(String contactId) async {
    await _contactsCollection.doc(contactId).delete();
  }
}
