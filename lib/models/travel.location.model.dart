import 'package:cloud_firestore/cloud_firestore.dart';

class TravelLocation {
  // Fields of the model
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String address;
  final double locationLatitude;
  final double locationLongitude;
  final String category;
  bool isSaved;

  // Constructor with default values
  TravelLocation({
    required this.id,
    this.name = '',
    this.description = '',
    this.imageUrl = '',
    this.address = '',
    this.locationLatitude = 0.0,
    this.locationLongitude = 0.0,
    this.category = '',
    this.isSaved = false,
  });

  // Factory constructor to create TravelLocation from a DocumentSnapshot
  factory TravelLocation.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return TravelLocation(
      id: snapshot.id,
      name: data?['name'] ?? '',
      description: data?['description'] ?? '',
      imageUrl: data?['imageUrl'] ?? '',
      address: data?['address'] ?? '',
      locationLatitude: (data?['locationLatitude'] ?? 0.0).toDouble(),
      locationLongitude: (data?['locationLongitude'] ?? 0.0).toDouble(),
      category: data?['category'] ?? '',
      isSaved: false,
    );
  }

  // Method to map the TravelLocation object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'address': address,
      'locationLatitude': locationLatitude,
      'locationLongitude': locationLongitude,
      'category': category,
    };
  }
}

List<TravelLocation> dummyLocations = [
  TravelLocation(
    id: '1',
    name: 'Sunny Beach',
    description: 'A beautiful sunny beach with golden sand and clear waters.',
    imageUrl:
        'https://www.balkanholidays.co.uk/lib/images/blog/480/sunny-beach.png',
    address: '123 Beachfront, Oceanview, CA',
    locationLatitude: 34.0522,
    locationLongitude: -118.2437,
    category: 'Beach',
  ),
  TravelLocation(
    id: '2',
    name: 'Evergreen Mountain',
    description: 'A towering mountain surrounded by lush evergreen forests.',
    imageUrl: 'https://cdn.5280.com/2016/06/evergreen-mountain.jpg',
    address: '456 Mountain Road, Forestville, CO',
    locationLatitude: 39.7392,
    locationLongitude: -104.9903,
    category: 'Mountains',
  ),
  TravelLocation(
    id: '3',
    name: 'Crystal Lake',
    description:
        'A serene lake known for its crystal-clear water and calm atmosphere.',
    imageUrl:
        'https://www.crystallake.org/home/showpublishedimage/2272/636114200754200000',
    address: '789 Lakeside, Clearview, MI',
    locationLatitude: 45.3145,
    locationLongitude: -85.6024,
    category: 'Lakes',
  ),
  TravelLocation(
    id: '4',
    name: 'Moonlit Camp',
    description:
        'A perfect spot for a camp under the stars with a mesmerizing view of the moonlit sky.',
    imageUrl: 'https://infinityfineart.com/images/moonlitcamp.jpg',
    address: '321 Wilderness Road, Stargazer, AZ',
    locationLatitude: 34.0489,
    locationLongitude: -111.0937,
    category: 'Camp',
  ),
  TravelLocation(
    id: '5',
    name: 'Emerald Mountain',
    description:
        'This mountain offers hiking trails with breathtaking views of emerald valleys.',
    imageUrl:
        'https://usercontent.one/wp/www.chernobyl.one/wp-content/uploads/2020/04/Emerald-Summer-Camp-19.jpg',
    address: '654 Summit Ave, Highland, UT',
    locationLatitude: 40.5598,
    locationLongitude: -111.8543,
    category: 'Mountains',
  ),
  TravelLocation(
    id: '6',
    name: 'Tropical Beach',
    description: 'A tropical paradise with palm trees and turquoise water.',
    imageUrl:
        'https://static.vecteezy.com/system/resources/previews/011/826/370/large_2x/maldives-islands-ocean-tropical-beach-exotic-sea-lagoon-palm-trees-over-white-sand-idyllic-nature-landscape-amazing-beach-scenic-shore-bright-tropical-summer-sun-and-blue-sky-with-light-clouds-photo.jpg',
    address: '987 Shoreline Drive, Paradise, FL',
    locationLatitude: 25.7617,
    locationLongitude: -80.1918,
    category: 'Beach',
  ),
  TravelLocation(
    id: '7',
    name: 'Pinewood Camp',
    description:
        'A camp surrounded by towering pine trees, perfect for outdoor adventures.',
    imageUrl:
        'https://www.pineforestcamp.com/wp-content/themes/pine-forest-camp/img/home-hero/slider/01_1_mobile.jpg?v=2022',
    address: '159 Pine Trail, Adventureland, WA',
    locationLatitude: 47.6062,
    locationLongitude: -122.3321,
    category: 'Camp',
  ),
  TravelLocation(
    id: '8',
    name: 'Misty Lake',
    description: 'A mysterious lake often covered in a beautiful morning mist.',
    imageUrl: 'https://i.redd.it/bb0s7or6h2y41.jpg',
    address: '852 Lakeview Blvd, Mystville, OR',
    locationLatitude: 44.0521,
    locationLongitude: -123.0868,
    category: 'Lakes',
  ),
  TravelLocation(
    id: '9',
    name: 'Snowpeak Mountain',
    description: 'A snow-covered peak, popular for skiing and winter sports.',
    imageUrl:
        'https://thumbs.dreamstime.com/b/snow-covered-mountain-peak-13135751.jpg',
    address: '741 Summit Pass, Snowville, CO',
    locationLatitude: 39.5501,
    locationLongitude: -105.7821,
    category: 'Mountains',
  ),
  TravelLocation(
    id: '10',
    name: 'Golden Sands Beach',
    description:
        'A beach with vast golden sands and clear blue water, ideal for sunbathing and surfing.',
    imageUrl:
        'https://www.worldbeachguide.com/photos/golden-sands-shoreline.jpg',
    address: '963 Sunshine Blvd, Surfside, CA',
    locationLatitude: 33.7683,
    locationLongitude: -118.1956,
    category: 'Beach',
  ),
];
