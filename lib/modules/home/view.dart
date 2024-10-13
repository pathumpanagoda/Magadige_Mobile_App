import 'package:flutter/material.dart';
import 'package:magadige/modules/feed/feed.list.dart';
import 'package:magadige/modules/home/home.view.dart';
import 'package:magadige/modules/home/saved.locations.view.dart';
import 'package:magadige/modules/notifications/view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  // List of screens that the bottom bar will navigate to
  List<Widget> get _pages => [
        HomeWidget(),
        SavedLocationsView(),
        const NotificationListView(),
        const FeedList(),
      ];

  // Function to handle tap on the BottomNavigationBar items
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Handle item tap
        selectedItemColor: Colors.green, // Set the color for selected items
        unselectedItemColor: Colors.grey, // Set the color for unselected items
        type: BottomNavigationBarType.fixed, // Ensures all items are visible
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Saved",
            icon: Icon(Icons.bookmark),
          ),
          BottomNavigationBarItem(
            label: "Notification",
            icon: Icon(Icons.notification_important),
          ),
          BottomNavigationBarItem(
            label: "Feed",
            icon: Icon(Icons.rss_feed),
          ),
        ],
      ),
    );
  }
}
