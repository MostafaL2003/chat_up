import 'package:chat_up/features/chat/services/chat_service.dart';
import 'package:chat_up/features/chat/widgets/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatRoom({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _textController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _textController.text.trim();
    if (message.isEmpty) return;
    setState(() {
      _isSending = true;
    });
    try {
      await ChatService().sendMessage(widget.receiverId, message);
      _textController.clear();
    } catch (_) {}
    setState(() {
      _isSending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.receiverName,
          style: theme.textTheme.titleLarge?.copyWith(
            color:
                theme.appBarTheme.foregroundColor ??
                theme.colorScheme.onPrimary,
          ),
        ),
        iconTheme: theme.appBarTheme.iconTheme,
        backgroundColor:
        
            theme.appBarTheme.backgroundColor ?? theme.colorScheme.primary,
        elevation: theme.appBarTheme.elevation ?? 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  currentUid == null
                      ? null
                      : FirebaseFirestore.instance
                          .collection('chat_rooms')
                          .doc(
                            ChatService().getChatRoomId(
                              currentUid,
                              widget.receiverId,
                            ),
                          )
                          .collection('messages')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
              builder: (context, snapshot) {
                if (currentUid == null) {
                  return const Center(child: Text("Not authenticated."));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading messages'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  );
                }
                final docs = snapshot.data?.docs ?? [];
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 8.0,
                  ),
                  itemCount: docs.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final data =
                        docs[index].data() as Map<String, dynamic>? ?? {};
                    final senderId = data['senderId'] ?? '';
                    final message = data['message'] ?? '';
                    Timestamp? timestamp = data['timestamp'];
                    DateTime date =
                        timestamp != null ? timestamp.toDate() : DateTime.now();
                    return Align(
                      alignment:
                          senderId == currentUid
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.0,
                          horizontal: 4.0,
                        ),
                        child: ChatBubble(
                          message: message,
                          isMe: senderId == currentUid,
                          time: date,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    minLines: 1,
                    maxLines: 3,
                    enabled: !_isSending,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: theme.colorScheme.primary),
                  onPressed: _isSending ? null : _sendMessage,
                  tooltip: 'Send',
                  splashRadius: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

