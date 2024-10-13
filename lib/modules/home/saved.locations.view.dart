import 'package:flutter/material.dart';
import 'package:magadige/constants.dart';
import 'package:magadige/models/travel.location.model.dart';
import 'package:magadige/modules/home/service.dart';
import 'package:magadige/modules/home/single.loaction.view.dart';

class SavedLocationsView extends StatelessWidget {
  final TravelLocationService _travelLocationService = TravelLocationService();

  SavedLocationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Locations',
          style: TextStyle(
            color: titleGrey,
          ),
        ),
      ),
      body: StreamBuilder<List<TravelLocation>>(
        stream: _travelLocationService.getSavedLocations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No saved locations yet.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final location = snapshot.data![index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(location.imageUrl),
                    ),
                    title: Text(location.name),
                    subtitle: Text(location.category),
                    trailing: IconButton(
                      icon: const Icon(Icons.bookmark_remove),
                      onPressed: () async {
                        await _travelLocationService
                            .unsaveLocation(location.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  '${location.name} removed from saved locations')),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SingleLocationView(location: location),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
