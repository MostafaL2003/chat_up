import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final String username;
  final String imageUrl;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const MyListTile({
    super.key,
    required this.username,
    required this.imageUrl,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
        child: imageUrl.isEmpty ? const Icon(Icons.person) : null,
      ),
      title: Text(username),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: onAccept,
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: onDecline,
          ),
        ],
      ),
    );
  }
}