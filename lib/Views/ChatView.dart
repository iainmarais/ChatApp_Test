// ignore_for_file: file_names, class_names, non_constant_identifier_names

//This will serve as the entry point for an active chat session. These details will have to be retrieved from the backend.

import "package:flutter/material.dart";

import "../Utils/AuthManager.dart";
import "LoginView.dart";
class ChatView extends StatefulWidget
{
  final AuthManager authManager;
  const ChatView({required this.authManager,super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}
class _ChatViewState extends State<ChatView>
{
  get authManager => widget.authManager;

  void HandleLogoff() async
  {
    final localContext = context;
    //Log the user off:
    await widget.authManager.client!.auth.signOut();
    //Navigate back to the login screen:
    if(!localContext.mounted)
    {
      return;
    }
    Navigator.of(localContext).pushReplacement(
      MaterialPageRoute(
        builder: (localContext) => LoginView(authManager: widget.authManager)
      )
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title:const Text("Chat"),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.logout),
            label:const Text("Log out"),
            //Need to fix this so that the supabase token is cleared when the user logs out, and return to the login page.
            onPressed: HandleLogoff,
            ),
          ],
        ),
      body:const Center(
        child: Text("If you're seeing this, you've managed to log in. Nice job!")
      )
    );
  }
}
