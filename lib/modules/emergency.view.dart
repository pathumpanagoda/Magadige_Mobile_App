import 'package:flutter/material.dart';

class EmergencyView extends StatelessWidget {
  const EmergencyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Emergency Message
            const Text(
              "It looks like you've\nbeen in a crash",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            // Description Text
            const Text(
              'App will trigger Emergency SOS if you don’t respond.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const Spacer(),
            // SOS Slider
            const SOSSlider(),
            const SizedBox(height: 50),
            // Cancel Button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(15),
                backgroundColor: Colors.red,
              ),
              child: const Icon(Icons.close, color: Colors.white),
            ),
            const Text(
              'Cancle',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class SOSSlider extends StatefulWidget {
  const SOSSlider({super.key});

  @override
  _SOSSliderState createState() => _SOSSliderState();
}

class _SOSSliderState extends State<SOSSlider> {
  double _sliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _sliderValue += details.delta.dx;
          if (_sliderValue < 0) _sliderValue = 0;
          if (_sliderValue > 200) {
            // Trigger SOS action here
            _sliderValue = 200;
            // Navigate to SOS confirmation or trigger SOS logic
          }
        });
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: 60,
            width: 250,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Text(
              'Slide Right →',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Positioned(
            left: _sliderValue,
            child: Container(
              height: 60,
              width: 60,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
