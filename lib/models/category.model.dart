import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String? id;
  final String name;
  final String imageUrl;

  // Constructor with default values
  CategoryModel({
    this.id,
    this.name = '',
    this.imageUrl = '',
  });

  // Factory constructor to create CategoryModel from a DocumentSnapshot
  factory CategoryModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return CategoryModel(
      id: snapshot.id,
      name: data?['name'] ?? '',
      imageUrl: data?['imageUrl'] ?? '',
    );
  }

  // Method to map the CategoryModel object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  // Factory constructor to create CategoryModel from a Map
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}

List<CategoryModel> categories = [
  CategoryModel(id: "1", name: "Mountains", imageUrl: "assets/mountain3.png"),
  CategoryModel(id: "2", name: "Beach", imageUrl: "assets/beach2.png"),
  CategoryModel(id: "3", name: "Lake", imageUrl: "assets/lake1.png"),
  CategoryModel(id: "4", name: "Camp", imageUrl: "assets/camp2.png"),
];
