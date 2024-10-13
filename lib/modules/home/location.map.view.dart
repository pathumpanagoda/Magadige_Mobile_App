import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:magadige/constants.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationMapView extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String imageUrl;

  const LocationMapView({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _LocationMapViewState createState() => _LocationMapViewState();
}

class _LocationMapViewState extends State<LocationMapView> {
  late GoogleMapController _controller;
  Color? _mapHue;
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _extractColor();
  }

  // Method to check and request location permissions
  Future<void> _checkLocationPermission() async {
    PermissionStatus status = await Permission.location.status;

    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      // Request permission if it hasn't been granted yet
      status = await Permission.location.request();
    }

    if (status.isGranted) {
      // If permission is granted, get the current location
      _getCurrentLocation();
    } else {
      // Handle the case when permission is not granted
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required.')),
      );
    }
  }

  Future<void> _extractColor() async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.imageUrl),
    );
    setState(() {
      _mapHue = paletteGenerator.dominantColor?.color ?? Colors.blue;
    });
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _updateMapStyle();
  }

  void _updateMapStyle() {
    if (_mapHue != null) {
      final hsl = HSLColor.fromColor(_mapHue!);
      final String mapStyle = '''
      [
        {
          "featureType": "all",
          "elementType": "geometry",
          "stylers": [
            {
              "hue": "${hsl.hue}"
            },
            {
              "saturation": ${hsl.saturation * 100}
            }
          ]
        }
      ]
      ''';
      _controller.setMapStyle(mapStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Location Map',
        style: TextStyle(color: titleGrey),
      )),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('destination'),
            position: LatLng(widget.latitude, widget.longitude),
            infoWindow: const InfoWindow(title: 'Destination'),
          ),
          if (_currentPosition != null)
            Marker(
              markerId: const MarkerId('current'),
              position: _currentPosition!,
              infoWindow: const InfoWindow(title: 'Your Location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure),
            ),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentPosition != null) {
            _controller.animateCamera(
              CameraUpdate.newLatLngZoom(_currentPosition!, 15),
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
