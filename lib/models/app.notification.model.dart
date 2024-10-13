class AppNotification {
  final String id;
  final String title;
  final String subtitle;
  final DateTime dateCreated;

  AppNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.dateCreated,
  });

  // Convert a notification to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'dateCreated': dateCreated.toIso8601String(),
    };
  }

  // Convert Firestore document to notification model
  factory AppNotification.fromMap(String id, Map<String, dynamic> data) {
    return AppNotification(
      id: id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      dateCreated: DateTime.parse(data['dateCreated']),
    );
  }
}
