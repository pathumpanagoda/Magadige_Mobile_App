import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magadige/constants.dart';
import 'package:magadige/modules/feed/create.view.dart';
import 'package:magadige/modules/feed/user.data.container.dart';
import 'package:magadige/modules/profile/view.dart';
import 'package:magadige/utils/index.dart';
import 'package:magadige/models/feed.model.dart';

class FeedList extends StatefulWidget {
  const FeedList({Key? key}) : super(key: key);

  @override
  _FeedListState createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _categories = [
    {'label': 'All', 'icon': Icons.all_inclusive, 'color': Colors.grey},
    {'label': 'Hotel', 'icon': Icons.hotel, 'color': Colors.green},
    {'label': 'Flight', 'icon': Icons.flight, 'color': Colors.blue},
    {'label': 'Bus', 'icon': Icons.directions_bus, 'color': Colors.orange},
    {'label': 'Boat', 'icon': Icons.directions_boat, 'color': Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          context.navigator(context, const CreateFeedView());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "Feed",
          style: TextStyle(color: titleGrey),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            onPressed: () {},
          ),
          InkWell(
            onTap: () {
              context.navigator(context, const ProfileView());
            },
            child: const CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: kToolbarHeight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _categories
                  .map((category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildCategoryChip(category['label'],
                            category['icon'], category['color']),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getFilteredStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final feeds = snapshot.data!.docs
                    .map((doc) => Feed.fromFirestore(doc))
                    .toList();

                return ListView.builder(
                  itemCount: feeds.length,
                  itemBuilder: (context, index) {
                    final feed = feeds[index];
                    return _buildFeedItem(feed);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, Color color) {
    return FilterChip(
      avatar: Icon(icon,
          color: _selectedCategory == label ? Colors.white : color, size: 18),
      label: Text(label,
          style: TextStyle(
              color: _selectedCategory == label ? Colors.white : Colors.black)),
      backgroundColor: _selectedCategory == label ? color : Colors.white,
      selected: _selectedCategory == label,
      onSelected: (bool selected) {
        setState(() {
          _selectedCategory = selected ? label : 'All';
        });
      },
    );
  }

  Widget _buildFeedItem(Feed feed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserDataContiner(uid: feed.userId),
          if (feed.imageUrl != null)
            Image.network(
              feed.imageUrl!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(feed.caption),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Category: ${feed.category.toUpperCase()}',
              style: TextStyle(
                  color: Colors.grey[600], fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getFilteredStream() {
    if (_selectedCategory == 'All') {
      return FirebaseFirestore.instance
          .collection('feeds')
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('feeds')
          .where('category', isEqualTo: _selectedCategory.toLowerCase())
          .orderBy('timestamp', descending: true)
          .snapshots();
    }
  }
}
