import 'package:flutter/material.dart';
import 'package:magadige/all.locations.view.dart';
import 'package:magadige/constants.dart';
import 'package:magadige/models/category.model.dart';
import 'package:magadige/models/travel.location.model.dart';
import 'package:magadige/modules/emergency.view.dart';
import 'package:magadige/modules/events/event.list.view.dart';
import 'package:magadige/modules/home/all.categories.view.dart';
import 'package:magadige/modules/home/all.locations.view.dart';
import 'package:magadige/modules/home/single.loaction.view.dart';
import 'package:magadige/modules/plan/create.plan.view.dart';
import 'package:magadige/modules/profile/view.dart';
import 'package:magadige/modules/shortcuts/all.shortcuts.view.dart';
import 'package:magadige/utils/index.dart';
import 'package:magadige/widgets/app.drawer.dart';

const String bannerImage =
    "http://provide.lk/wp-content/uploads/2024/10/appBanner.jpg";

class HomeWidget extends StatelessWidget {
  final List<TravelLocation> locations =
      dummyLocations; // Use the dummy data here

  HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          context.navigator(context, const CreatePlanView());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Sliver AppBar with animation
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
              background: Image.network(
                bannerImage,
                fit: BoxFit.cover,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  child: IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      context.navigator(context, const ProfileView());
                    },
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(5, 5),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search any places...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      context.navigator(context, const AllCategoriesView());
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                    categories.map((e) => _CategoryIcon(category: e)).toList(),
              ),
            ),
          ),

          // Most Visited Locations
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Most Visited',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      context.navigator(context, const AllLocationsView());
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 150.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  final location = locations[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _MostVisitedCard(location: location),
                  );
                },
              ),
            ),
          ),

          // Shortcuts Section
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Shortcuts',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      context.navigator(context, const AllShortCutsView());
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ShortcutButton(
                    label: 'Emergency',
                    icon: Icons.warning,
                    onTap: () {
                      context.navigator(context, const EmergencyView());
                    },
                  ),
                  _ShortcutButton(
                    label: 'Map',
                    icon: Icons.map,
                    onTap: () {
                      context.navigator(context, const AllLocationsMapView());
                    },
                  ),
                  _ShortcutButton(
                    label: 'Trips',
                    icon: Icons.directions_car,
                    onTap: () {
                      context.navigator(context, const EventListView());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final CategoryModel category;

  const _CategoryIcon({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.green[100],
          child: Image.asset(category.imageUrl),
        ),
        const SizedBox(height: 8),
        Text(category.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _MostVisitedCard extends StatelessWidget {
  final TravelLocation location;

  const _MostVisitedCard({
    Key? key,
    required this.location,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.navigator(context, SingleLocationView(location: location));
      },
      child: SizedBox(
        width: 170,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  location.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    location.name,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShortcutButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ShortcutButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.green[100],
            child: Icon(icon, color: Colors.green),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
