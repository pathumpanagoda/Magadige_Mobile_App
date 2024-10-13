import 'package:flutter/material.dart';
import 'package:magadige/modules/feed/user.data.container.dart';
import 'package:magadige/modules/review/service.dart';
import 'package:magadige/models/review.model.dart';

class LocationReviews extends StatelessWidget {
  final String locationId;
  const LocationReviews({super.key, required this.locationId});

  @override
  Widget build(BuildContext context) {
    final ReviewService _reviewService = ReviewService();

    return StreamBuilder<List<Review>>(
      stream: _reviewService.getReviewsByLocation(locationId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No reviews yet.'));
        }

        final reviews = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: kToolbarHeight,
                    child: UserDataContiner(
                      uid: review.userId,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            starIndex < review.numStars
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(review.review),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
