import 'package:flutter/material.dart';
import 'package:magadige/all.locations.view.dart';
import 'package:magadige/modules/emergency.view.dart';
import 'package:magadige/modules/shortcuts/currency.converter.dart';
import 'package:magadige/modules/shortcuts/emergency.contacts.list.dart';
import 'package:magadige/modules/shortcuts/weather.view.dart';
import 'package:magadige/utils/index.dart';

class AllShortCutsView extends StatelessWidget {
  const AllShortCutsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Extra Services",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildServiceItem(
            Icons.map,
            "Offline Maps",
            Colors.green,
            () {
              context.navigator(context, const AllLocationsMapView());
            },
          ),
          _buildServiceItem(
            Icons.cloud,
            "Weather Forecast",
            Colors.green,
            () {
              context.navigator(context, const WeatherView());
            },
          ),
          _buildServiceItem(
            Icons.translate,
            "Language Translator",
            Colors.green,
            () {},
          ),
          _buildServiceItem(
            Icons.currency_exchange,
            "Exchange Currency",
            Colors.green,
            () {},
          ),
          _buildServiceItem(
            Icons.compare_arrows,
            "Currency Converter",
            Colors.green,
            () {
              context.navigator(context, const CurrencyConvertView());
            },
          ),
          _buildServiceItem(
            Icons.contact_phone,
            "Emergency Contacts",
            Colors.green,
            () {
              context.navigator(context, const EmergenceContactsList());
            },
          ),
          _buildServiceItem(
            Icons.support_agent,
            "Emergency Assistant",
            Colors.green,
            () {},
          ),
          _buildSOSTrigger(context),
        ],
      ),
    );
  }

  Widget _buildServiceItem(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSOSTrigger(BuildContext context) {
    return InkWell(
      onTap: () {
        context.navigator(context, const EmergencyView());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  "SOS",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "SOS Trigger",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
