import 'package:chat_up/features/chat/screens/search_screen.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
            icon: Icon(Icons.access_alarm_outlined),
          ),
        ],
      ),
      body: Text("dslgkjlsdkgllkskldklgkskjjklgklskldjgjklsklgjj"),
    );
  }
}
