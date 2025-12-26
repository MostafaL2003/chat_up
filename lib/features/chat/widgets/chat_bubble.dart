import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime time;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = 20.0;
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.72,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color:
                isMe
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
              bottomLeft: Radius.circular(isMe ? radius : 6),
              bottomRight: Radius.circular(isMe ? 6 : radius),
            ),
          ),
          child: Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color:
                  isMe
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 3),
        Padding(
          padding: EdgeInsets.only(left: isMe ? 0 : 6, right: isMe ? 6 : 0),
          child: Text(
            DateFormat('HH:mm').format(time),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
              fontSize: 11,
            ),
          ),
        ),
      
      ],
    );
  }
}