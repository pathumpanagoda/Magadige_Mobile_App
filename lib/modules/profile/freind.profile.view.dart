import 'package:flutter/material.dart';
import 'package:magadige/constants.dart';
import 'package:magadige/models/app.user.model.dart';
import 'package:magadige/models/feed.model.dart';
import 'package:magadige/modules/feed/service.dart';
import 'package:magadige/services/user.follow.service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendProfileView extends StatefulWidget {
  final String uid;
  final AppUser user;
  const FriendProfileView({super.key, required this.uid, required this.user});

  @override
  _FriendProfileViewState createState() => _FriendProfileViewState();
}

class _FriendProfileViewState extends State<FriendProfileView> {
  final UserFollowService _followService = UserFollowService();
  final FeedService _feedService = FeedService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isFollowing = false;
  int _followerCount = 0;
  int _followingCount = 0;
  int _feedCount = 0;
  List<Feed> _feeds = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final isFollowing =
          await _followService.isFollowing(widget.uid, currentUser.uid);
      final followerCount = await _followService.getFollowerCount(widget.uid);
      final followingCount =
          await _followService.getFollowerCount(currentUser.uid);
      final feeds = await _feedService.getUserFeeds(widget.uid);

      setState(() {
        _isFollowing = isFollowing;
        _followerCount = followerCount;
        _followingCount = followingCount;
        _feeds = feeds;
        _feedCount = feeds.length;
      });
    }
  }

  Future<void> _toggleFollow() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      if (_isFollowing) {
        await _followService.removeFollower(widget.uid, currentUser.uid);
      } else {
        await _followService.addFollower(widget.uid, currentUser.uid);
      }
      await _loadProfileData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.user.fullName,
          style: const TextStyle(color: titleGrey),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(widget.user.imageUrl ??
                        "https://www.svgrepo.com/show/508699/landscape-placeholder.svg"),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn('$_feedCount', 'Posts'),
                        _buildStatColumn('$_followerCount', 'Followers'),
                        _buildStatColumn('$_followingCount', 'Following'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.fullName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(widget.user.bio ?? ""),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _toggleFollow,
                          child: Text(
                            _isFollowing ? 'Unfollow' : 'Follow',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _isFollowing ? Colors.grey : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemCount: _feeds.length,
              itemBuilder: (context, index) {
                return Image.network(
                  _feeds[index].imageUrl ??
                      'https://placehold.co/600x400?text=No+Image',
                  fit: BoxFit.cover,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(label),
      ],
    );
  }
}
