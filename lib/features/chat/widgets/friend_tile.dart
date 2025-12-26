import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_up/features/chat/screens/chat_room.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendTile extends StatefulWidget {
  final String uid;
  const FriendTile({super.key, required this.uid});

  @override
  State<FriendTile> createState() => _FriendTileState();
}

class _FriendTileState extends State<FriendTile> {
  String _username = '';
  String _imageUrl = '';
  bool _loadingProfile = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          _username = data['username'] ?? '';
          _imageUrl = data['imageUrl'] ?? '';
          _loadingProfile = false;
        });
      } else {
        setState(() {
          _username = 'User';
          _imageUrl = '';
          _loadingProfile = false;
        });
      }
    } catch (e) {
      setState(() {
        _username = "User";
        _imageUrl = '';
        _loadingProfile = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loadingProfile) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        child: SizedBox(
          height: 60,
          child: Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }

    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUid == null) {
      return ListTile(title: Text("User not authenticated"));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('users')
              .doc(currentUid)
              .collection('friends')
              .doc(widget.uid)
              .snapshots(),
      builder: (context, snapshot) {
        String displayMessage = 'No messages yet';
        DateTime? time;
        bool fromCurrentUser = false;
        bool hasUnread = false;

        if (snapshot.hasData && snapshot.data?.data() != null) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final lastMessageRaw = data['lastMessage'] as String?;
          final senderId = data['senderId'] as String?;
          final Timestamp? timestamp = data['timestamp'] as Timestamp?;
          hasUnread = (data['unread'] == true);

          if (lastMessageRaw != null && lastMessageRaw.trim().isNotEmpty) {
            if (senderId != null && senderId == currentUid) {
              displayMessage = 'You: $lastMessageRaw';
              fromCurrentUser = true;
            } else {
              displayMessage = lastMessageRaw;
              fromCurrentUser = false;
            }
          }
          if (timestamp != null) {
            time = timestamp.toDate();
          }
        }

        return Material(
          color: theme.colorScheme.surface,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ChatRoom(
                        receiverId: widget.uid,
                        receiverName: _username,
                      ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 12.0,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(color: theme.dividerColor, width: 0.5),
                ),
              ),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.outline.withOpacity(0.22),
                            width: 1.1,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          backgroundImage:
                              _imageUrl.isNotEmpty
                                  ? NetworkImage(_imageUrl)
                                  : null,
                          child:
                              _imageUrl.isEmpty
                                  ? Icon(
                                    Icons.person,
                                    size: 32,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  )
                                  : null,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _username,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    displayMessage,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight:
                                          hasUnread && !fromCurrentUser
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                      color:
                                          hasUnread && !fromCurrentUser
                                              ? theme.colorScheme.onSurface
                                                  .withOpacity(0.92)
                                              : theme.textTheme.bodySmall?.color
                                                  ?.withOpacity(0.75),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (hasUnread && !fromCurrentUser)
                                  Container(
                                    margin: const EdgeInsets.only(left: 7),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (time != null)
                    Positioned(
                      top: 2,
                      right: 0,
                      child: Text(
                        _buildTimeText(time),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(
                            0.5,
                          ),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _buildTimeText(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays > 0) {
      return "${dateTime.month}/${dateTime.day}";
    } else if (diff.inHours > 0) {
      return "${diff.inHours}h ago";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes}m ago";
    } else {
      return "now";
    }
  }
}
