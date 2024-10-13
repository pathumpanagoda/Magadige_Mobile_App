import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Star rating widget
import 'package:magadige/constants.dart';
import 'package:magadige/models/review.model.dart';
import 'package:magadige/models/travel.location.model.dart';
import 'package:magadige/modules/home/location.map.view.dart';
import 'package:magadige/modules/home/service.dart';
import 'package:magadige/modules/plan/create.plan.view.dart';
import 'package:magadige/modules/review/location.reviews.dart';
import 'package:magadige/modules/review/service.dart';
import 'package:magadige/utils/index.dart';
import 'package:magadige/widgets/custom.filled.button.dart';

class SingleLocationView extends StatefulWidget {
  final TravelLocation location;
  const SingleLocationView({Key? key, required this.location})
      : super(key: key);

  @override
  State<SingleLocationView> createState() => _SingleLocationViewState();
}

class _SingleLocationViewState extends State<SingleLocationView> {
  bool _isSaved = false;
  final _travelLocationService = TravelLocationService();
  Future<void> _checkIfSaved() async {
    bool isSaved =
        await _travelLocationService.isLocationSaved(widget.location.id);
    setState(() {
      _isSaved = isSaved;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  Future<void> _toggleSave() async {
    setState(() {
      _isSaved = !_isSaved;
    });

    if (_isSaved) {
      await _travelLocationService.saveLocation(widget.location);
      context.showSnackBar("Location saved successfully");
    } else {
      await _travelLocationService.unsaveLocation(widget.location.id);
      context.showSnackBar("Location unsaved successfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.location.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.location.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: titleGrey),
                      ),
                      IconButton(
                        onPressed: _toggleSave,
                        icon: Icon(
                            _isSaved ? Icons.bookmark : Icons.bookmark_border),
                        color: primaryColor,
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.location.category,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Colors.blue,
                        ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "About",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.grey, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.location.description,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(widget.location.address),
                  ),
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text(
                      'Latitude: ${widget.location.locationLatitude.toStringAsFixed(4)}, Longitude: ${widget.location.locationLongitude.toStringAsFixed(4)}',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: CustomButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LocationMapView(
                                latitude: widget.location.locationLatitude,
                                longitude: widget.location.locationLongitude,
                                imageUrl: widget.location.imageUrl,
                              ),
                            ));
                          },
                          text: "View On Map",
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: CustomButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const CreatePlanView(),
                            ));
                          },
                          text: "Add to plan",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomButton(
                    text: "Add a Review",
                    onPressed: () {
                      _showReviewDialog(context, widget.location);
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Reviews",
                    style: TextStyle(fontSize: 18, color: titleGrey),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  LocationReviews(locationId: widget.location.id),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to show the review dialog
  void _showReviewDialog(BuildContext context, TravelLocation location) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReviewDialog(location: location);
      },
    );
  }
}

// Review dialog widget
class ReviewDialog extends StatefulWidget {
  final TravelLocation location;
  const ReviewDialog({Key? key, required this.location}) : super(key: key);

  @override
  _ReviewDialogState createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  final ReviewService _reviewService = ReviewService();
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a Review'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Star rating widget
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          const SizedBox(height: 16),
          // Review text input
          TextField(
            controller: _reviewController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Enter your review',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (_rating > 0 && _reviewController.text.isNotEmpty) {
              // Save review to Firebase
              Review newReview = Review(
                id: '',
                userId: FirebaseAuth.instance.currentUser?.uid ?? "",
                locationId: widget.location.id,
                review: _reviewController.text,
                numStars: _rating.round(),
              );
              await _reviewService.createReview(newReview);
              context.showSnackBar("Review submitted successfully");
              Navigator.pop(context);
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
