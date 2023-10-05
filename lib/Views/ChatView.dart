// ignore_for_file: file_names, class_names, non_constant_identifier_names

//This will serve as the entry point for an active chat session. These details will have to be retrieved from the backend.
import "package:flutter/material.dart";

class ChatView extends StatefulWidget
{
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}
class _ChatViewState extends State<ChatView>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title:const Text("Chat")
      ),
      body:const Center(child: Text("If you're seeing this, you've managed to log in. Nice job!")
      )
    );
  }
}