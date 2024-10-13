import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({Key? key}) : super(key: key);

  @override
  _WeatherViewState createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  final String apiKey = 'f07573bf8be6a045d3f805a9a5517103';
  String city = 'Kandy,LK';
  Map<String, dynamic>? currentWeather;
  List<dynamic>? forecast;
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    setState(() {
      isLoading = true;
    });

    final currentUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
    final forecastUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric';

    try {
      final currentResponse = await http.get(Uri.parse(currentUrl));
      final forecastResponse = await http.get(Uri.parse(forecastUrl));

      if (currentResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        setState(() {
          currentWeather = json.decode(currentResponse.body);
          forecast = json.decode(forecastResponse.body)['list'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Location'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(hintText: "Enter city name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Search'),
              onPressed: () {
                setState(() {
                  city = _searchController.text;
                });
                fetchWeatherData();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Extra Services',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildLocationChip(),
                  _buildCurrentWeather(),
                  _buildForecast(),
                ],
              ),
            ),
    );
  }

  Widget _buildLocationChip() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Chip(
        avatar: const Icon(Icons.location_on, size: 18),
        label: Text(city.split(',')[0]),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildCurrentWeather() {
    if (currentWeather == null) return const SizedBox.shrink();

    final temp = currentWeather!['main']['temp'].round();
    final feelsLike = currentWeather!['main']['feels_like'].round();
    final description = currentWeather!['weather'][0]['description'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue, Colors.lightBlueAccent],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$city\n${DateFormat('d MMMM y | HH:mm').format(DateTime.now())}',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${temp}°C',
                style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.cloudy_snowing, color: Colors.white, size: 48),
            ],
          ),
          Text(
            'Temp ${temp}°C, Feels like ${feelsLike}°C',
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            description.toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildForecast() {
    if (forecast == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Next Destinations',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...forecast!.take(3).map((item) => _buildForecastItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildForecastItem(dynamic item) {
    final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
    final minTemp = item['main']['temp_min'].round();
    final maxTemp = item['main']['temp_max'].round();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(DateFormat('EEEE, d MMM').format(date)),
        subtitle: Text('Day ${maxTemp}°C, Night ${minTemp}°C'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud, color: Colors.blue),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
