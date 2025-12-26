import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final VoidCallback? onProfileSettings;
  final VoidCallback? onSecondAction;
  final VoidCallback? onLogout;

  MyDrawer({
    super.key,
    this.onProfileSettings,
    this.onSecondAction,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Drawer(
      child: StreamBuilder<DocumentSnapshot>(
        stream:
            uid != null
                ? FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .snapshots()
                : null,
        builder: (context, snapshot) {
          String username = "User";
          String imageUrl = "";

          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            username = data['username'] ?? "User";
            imageUrl = data['imageUrl'] ?? "";
          }

          return Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      key: UniqueKey(),
                      radius: 36,
                      backgroundImage:
                          imageUrl.isNotEmpty
                              ? NetworkImage(
                                imageUrl +
                                    "?t=" +
                                    DateTime.now().millisecondsSinceEpoch
                                        .toString(),
                              )
                              : null,
                      child:
                          imageUrl.isEmpty
                              ? Icon(
                                Icons.person,
                                size: 48.0,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                              )
                              : null,
                    ),
                    SizedBox(height: 16),
                    Text(
                      username,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  "Profile Settings",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: onProfileSettings,
              ),
              ListTile(
                leading: Icon(
                  Icons.group,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  "Manage Friends",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: onSecondAction,
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    "Logout",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onTap: onLogout,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
