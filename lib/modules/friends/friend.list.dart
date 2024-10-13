import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:magadige/constants.dart';
import 'package:magadige/models/app.notification.model.dart';
import 'package:magadige/modules/feed/user.data.container.dart';
import 'package:magadige/modules/notifications/servie.dart';
import 'package:magadige/utils/index.dart';

class FriendList extends StatelessWidget {
  const FriendList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Friend List",
          style: TextStyle(color: titleGrey),
        ),
      ),
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("user_follows").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: Text("Go to feed and follow some friends"),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("Go to feed and follow some friends"),
              );
            }

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  List ids =
                      (snapshot.data!.docs[index].data() as Map)["followerIds"];
                  if (ids.contains(FirebaseAuth.instance.currentUser?.uid)) {
                    return UserDataContiner(
                      uid: snapshot.data!.docs[index].id,
                      onTap: () async {
                        AppNotification notification = AppNotification(
                            id: '',
                            title: 'New invitation',
                            subtitle: 'New invitation is being created',
                            dateCreated: DateTime.now());
                        await NotificationService()
                            .createNotification(notification)
                            .then((value) =>
                                context.showSnackBar("Invitation sent"));
                      },
                    );
                  }
                  return Container();
                });
          }),
    );
  }
}
