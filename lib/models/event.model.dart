class Event {
  String id;
  String name;
  String description;
  String imageUrl;
  String userId;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.userId,
  });

  // Convert Event to a Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'userId': userId,
    };
  }

  // Create an Event object from Firebase data
  factory Event.fromMap(String id, Map<String, dynamic> map) {
    return Event(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      userId: map['userId'] ?? '',
    );
  }
}
