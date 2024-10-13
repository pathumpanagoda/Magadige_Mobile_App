import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:magadige/constants.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:magadige/models/travel.location.model.dart';

class AllLocationsMapView extends StatefulWidget {
  const AllLocationsMapView({super.key});

  @override
  _AllLocationsMapViewState createState() => _AllLocationsMapViewState();
}

class _AllLocationsMapViewState extends State<AllLocationsMapView> {
  late GoogleMapController _controller;
  List<TravelLocation> locations = dummyLocations;
  Map<String, BitmapDescriptor> _locationIcons = {};

  @override
  void initState() {
    super.initState();
    _loadLocationMarkers();
  }

  // Method to load custom markers with hues extracted from location images
  Future<void> _loadLocationMarkers() async {
    for (var location in locations) {
      final icon = await _createMarkerIcon(location.imageUrl);
      setState(() {
        _locationIcons[location.id] = icon;
      });
    }
  }

  // Method to create circular marker icons with color extraction
  Future<BitmapDescriptor> _createMarkerIcon(String imageUrl) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(NetworkImage(imageUrl));
    final dominantColor = paletteGenerator.dominantColor?.color ?? Colors.blue;

    return BitmapDescriptor.defaultMarkerWithHue(
      HSLColor.fromColor(dominantColor).hue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Locations Map',
          style: TextStyle(color: titleGrey),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0), // Set to a reasonable default
          zoom: 2,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          _showAllLocationMarkers();
        },
        markers: locations.map((location) {
          return Marker(
            markerId: MarkerId(location.id),
            position:
                LatLng(location.locationLatitude, location.locationLongitude),
            icon: _locationIcons[location.id] ?? BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: location.name),
          );
        }).toSet(),
      ),
    );
  }

  // Center the map to show all markers once they're loaded
  void _showAllLocationMarkers() {
    if (locations.isEmpty) return;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        locations
            .map((l) => l.locationLatitude)
            .reduce((a, b) => a < b ? a : b),
        locations
            .map((l) => l.locationLongitude)
            .reduce((a, b) => a < b ? a : b),
      ),
      northeast: LatLng(
        locations
            .map((l) => l.locationLatitude)
            .reduce((a, b) => a > b ? a : b),
        locations
            .map((l) => l.locationLongitude)
            .reduce((a, b) => a > b ? a : b),
      ),
    );

    _controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }
}
