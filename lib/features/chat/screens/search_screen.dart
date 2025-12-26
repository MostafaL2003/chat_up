// ignore_for_file: avoid_print

import 'package:chat_up/features/auth/cubit/auth_cubit.dart';
import 'package:chat_up/features/chat/services/chat_service.dart';
import 'package:chat_up/features/auth/cubit/auth_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_up/features/auth/widgets/my_text_field.dart';
import 'package:chat_up/features/chat/widgets/my_list_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? errorMessage;
  bool isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Friends'), centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    errorText: errorMessage,
                    hintText: 'Search for friends',
                    obscureText: false,
                    controller: _searchController,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon:
                      isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.person_add_alt_1),
                  onPressed:
                      isLoading
                          ? null
                          : () async {
                            setState(() {
                              isLoading = true;
                              errorMessage = null;
                            });

                            try {
                              final authState = context.read<AuthCubit>().state;
                              if (authState is AuthSuccess) {
                                await ChatService().sendFriendRequest(
                                  _searchController.text.trim(),
                                  authState.userModel.username,
                                  authState.userModel.imageUrl,
                                );

                                _searchController.clear();

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Friend request sent!"),
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              setState(() => errorMessage = e.toString());
                            } finally {
                              setState(() => isLoading = false);
                            }
                          },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
            child: Text(
              'Incoming Friend Requests',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ChatService().getFriendRequests(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(child: Text('No requests'));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return MyListTile(
                      username: data['senderUsername'] ?? 'User',
                      imageUrl: data['senderImageUrl'] ?? '',
                      onAccept: () async {
                        final data = docs[index].data() as Map<String, dynamic>;
                        final requestId = docs[index].id;
                        final senderId = data['senderId'];

                        await ChatService().acceptFriendRequest(
                          requestId,
                          senderId,
                        );
                      },
                      onDecline: () async {
                        try {
                          ChatService().declineFriendRequest;

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Request declined")),
                            );
                          }
                        } catch (e) {
                          print("Error deleting request: $e");
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
