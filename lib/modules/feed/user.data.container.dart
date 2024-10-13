import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:magadige/models/app.user.model.dart';
import 'package:magadige/modules/profile/freind.profile.view.dart';
import 'package:magadige/modules/profile/view.dart';
import 'package:magadige/utils/index.dart';

class UserDataContiner extends StatelessWidget {
  final String uid;
  final VoidCallback? onTap;
  const UserDataContiner({super.key, required this.uid, this.onTap});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.data == null) {
            return const SizedBox.shrink();
          }
          if (!snapshot.data!.exists) {
            return const SizedBox.shrink();
          }
          AppUser user = AppUser.fromDocumentSnapshot(snapshot.data!);
          return InkWell(
            onTap: onTap ??
                () {
                  if (user.id == FirebaseAuth.instance.currentUser?.uid) {
                    context.navigator(context, const ProfileView());
                  } else {
                    context.navigator(
                        context, FriendProfileView(uid: uid, user: user));
                  }
                },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage('${user.imageUrl}'),
              ),
              title: Text(user.fullName),
            ),
          );
        });
  }
}
