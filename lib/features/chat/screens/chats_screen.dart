import 'package:chat_up/features/auth/cubit/auth_cubit.dart';
import 'package:chat_up/features/chat/widgets/my_drawer.dart';
import 'package:chat_up/features/chat/widgets/friend_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'search_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            tooltip: 'Add Friends',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      drawer: MyDrawer(
        onProfileSettings: () {
          // TODO: Implement navigation to profile settings if needed
        },
        onSecondAction: () {
          Navigator.pop(context);
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const SearchScreen()));
        },
        onLogout: () {
          context.read<AuthCubit>().logOut(context);
        },
      ),
      body:
          currentUid == null
              ? Center(
                child: Text(
                  'Not authenticated.',
                  style: theme.textTheme.bodyLarge,
                ),
              )
              : StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUid)
                        .collection('friends')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Something went wrong.',
                        style: theme.textTheme.bodyLarge,
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                    );
                  }
                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.group_outlined,
                            size: 60,
                            color: theme.colorScheme.primary.withOpacity(0.2),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "No friends yet",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Tap the button on top right to add friends!",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      return FriendTile(uid: doc.id);
                    },
                  );
                },
              ),
    );
  }
}
