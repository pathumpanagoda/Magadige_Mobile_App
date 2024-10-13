import 'package:flutter/material.dart';
import 'package:magadige/models/travel.location.model.dart';
import 'package:magadige/modules/home/location.map.view.dart';
import 'package:magadige/modules/home/single.loaction.view.dart';
import 'package:magadige/utils/index.dart';
import 'package:magadige/widgets/custom.filled.button.dart';

class HanthanaMountainCard extends StatelessWidget {
  final TravelLocation location;
  const HanthanaMountainCard({Key? key, required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            location.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.name,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.green, size: 20),
                    const SizedBox(width: 4),
                    const Text(
                      '4.4',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(150)',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.grey, size: 20),
                    SizedBox(width: 4),
                    Text(location.category),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.nature, color: Colors.grey, size: 20),
                    SizedBox(width: 4),
                    Text('Adventure'),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                    child: CustomButton(
                  text: "Add to Trip",
                  onPressed: () {},
                )),
                const SizedBox(width: 8),
                Expanded(
                    child: CustomButton(
                  text: "View on Map",
                  onPressed: () {
                    context.navigator(
                        context,
                        LocationMapView(
                            latitude: location.locationLatitude,
                            longitude: location.locationLongitude,
                            imageUrl: location.imageUrl));
                  },
                )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {
                context.navigator(
                    context, SingleLocationView(location: location));
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'View More Details',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: Colors.blue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
