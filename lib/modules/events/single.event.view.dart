import 'package:flutter/material.dart';
import 'package:magadige/constants.dart';
import 'package:magadige/models/event.model.dart';
import 'package:magadige/modules/feed/user.data.container.dart';

class SingleEventView extends StatelessWidget {
  final Event event;
  const SingleEventView({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          event.name,
          style: const TextStyle(color: titleGrey),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            event.imageUrl.isNotEmpty
                ? Image.network(
                    event.imageUrl,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  )
                : const SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
            const SizedBox(height: 16),

            // Event name
            Text(
              event.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Event description
            Text(
              event.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),

            // Additional content
            const Text(
              'Organized by:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            UserDataContiner(uid: event.userId)
          ],
        ),
      ),
    );
  }
}
