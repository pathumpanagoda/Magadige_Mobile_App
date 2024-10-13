import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:magadige/models/emergency.contact.model.dart';
import 'package:magadige/modules/shortcuts/create.contact.view.dart';
import 'package:magadige/modules/shortcuts/emergency.contact.service.dart';
import 'package:magadige/utils/index.dart';

class EmergenceContactsList extends StatefulWidget {
  const EmergenceContactsList({Key? key}) : super(key: key);

  @override
  _EmergenceContactsListState createState() => _EmergenceContactsListState();
}

class _EmergenceContactsListState extends State<EmergenceContactsList> {
  final EmergencyContactService _contactService = EmergencyContactService();
  late Future<List<EmergencyContact>> _contactsFuture;

  @override
  void initState() {
    super.initState();
    _contactsFuture = _loadContacts();
  }

  Future<List<EmergencyContact>> _loadContacts() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return await _contactService.getContacts(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Emergency Contacts',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<EmergencyContact>>(
        future: _contactsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No emergency contacts found.'));
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                _contactsFuture = _loadContacts();
                setState(() {});
              },
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  EmergencyContact contact = snapshot.data![index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: contact.imageUrl != null
                          ? NetworkImage(contact.imageUrl!)
                          : null,
                      child: contact.imageUrl == null
                          ? Text(contact.name[0])
                          : null,
                    ),
                    title: Text(contact.name),
                    subtitle: Text(contact.contact),
                    trailing: IconButton(
                      icon: const Icon(Icons.phone, color: Colors.green),
                      onPressed: () {},
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          child: const Text(
            'Add New Contact',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
          ),
          onPressed: () {
            context.navigator(context, const CreateContact());
          },
        ),
      ),
    );
  }
}
