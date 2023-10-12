// ignore_for_file: file_names, class_names, non_constant_identifier_names

//needed for all UI elements.
import "package:flutter/material.dart";

import "../Utils/AuthManager.dart";
class ChatListView extends StatefulWidget
{
  final AuthManager authManager;
  const ChatListView({super.key, required this.authManager});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView>
{

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title:const Text("Chat")
      ),
      //Here we need to build out a list of the user's active chats by querying the database. 
      //We also need to ensure the user is logged in and has a valid token.
      body:const Center(child: Text("If you're seeing this, you've managed to log in. Nice job!")
      )
    );
  }
}