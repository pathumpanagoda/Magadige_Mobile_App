import 'package:flutter/material.dart';
import 'package:magadige/constants.dart';
import 'package:magadige/modules/auth/login.dart';
import 'package:magadige/modules/auth/service.dart';
import 'package:magadige/modules/home/add.location.view.dart';
import 'package:magadige/modules/plan/plan.list.dart';
import 'package:magadige/utils/index.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          ListTile(
            title: Text('My Plans'),
            onTap: () {
              context.navigator(context, const PlanList());
            },
          ),
          ListTile(
            title: Text('Add Location'),
            onTap: () {
              context.navigator(context, const AddLocationView());
            },
          ),
          ListTile(
            title: Text('Themes'),
            onTap: () {
              // Handle themes
            },
          ),
          ListTile(
            title: Text('Extra Services'),
            onTap: () {
              // Handle extra services
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              // Handle settings
            },
          ),
          ListTile(
            title: Text('Customer Support'),
            onTap: () {
              // Handle customer support
            },
          ),
          ListTile(
            title: Text('Report a Bug'),
            onTap: () {
              // Handle bug report
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'MagaDige v.1.0',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ],
              ),
              onPressed: () {
                AuthService().signOut().then((value) => context
                    .navigator(context, const LoginView(), shouldBack: false));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
