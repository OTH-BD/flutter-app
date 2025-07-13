import 'package:flutter/material.dart';
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Chat", style: TextStyle(color: Theme.of(context).indicatorColor),),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Text("Chat Page"),
      ),
    );
  }
}
