import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:magadige/constants.dart';
import 'package:magadige/models/event.model.dart';
import 'package:magadige/modules/event/service.dart';
import 'package:magadige/modules/events/create.dart';
import 'package:magadige/modules/events/single.event.view.dart';
import 'package:magadige/utils/index.dart';

class EventListView extends StatelessWidget {
  const EventListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Events',
          style: TextStyle(color: titleGrey),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateEventView(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Event>>(
        stream: EventService().getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading events'));
          }

          final events = snapshot.data ?? [];

          if (events.isEmpty) {
            return const Center(child: Text('No events available'));
          }

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                onTap: () {
                  context.navigator(context, SingleEventView(event: event));
                },
                title: Text(event.name),
                subtitle: Text(event.description),
                leading: Image.network(event.imageUrl, width: 50, height: 50),
                trailing: event.userId == FirebaseAuth.instance.currentUser?.uid
                    ? IconButton(
                        onPressed: () {
                          EventService().deleteEvent(event.id);
                        },
                        icon: Icon(Icons.delete))
                    : const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
