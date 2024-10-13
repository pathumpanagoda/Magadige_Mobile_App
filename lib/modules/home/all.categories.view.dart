import 'package:flutter/material.dart';
import 'package:magadige/models/category.model.dart';

class AllCategoriesView extends StatelessWidget {
  const AllCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Cateogories",
          style: TextStyle(
            color: Colors.grey[800],
          ),
        ),
      ),
      body: GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4),
          itemBuilder: (context, index) {
            CategoryModel category = categories[index];
            return InkWell(
              onTap: () {},
              child: Card(
                color: Colors.white,
                child: Image.asset(category.imageUrl),
              ),
            );
          }),
    );
  }
}
