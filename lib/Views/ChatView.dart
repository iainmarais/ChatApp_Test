// ignore_for_file: file_names, class_names, non_constant_identifier_names

//This will serve as the entry point for an active chat session. These details will have to be retrieved from the backend.
import "./LoginView.dart";
import "package:flutter/material.dart";
import "../Utils/SharedPrefs.dart";
import "../Utils/AuthController.dart";

class ChatView extends StatefulWidget
{
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}
class _ChatViewState extends State<ChatView>
{
  final _authController = AuthController();
  void _HandleLogoff()
  {
    SharedPrefs.ClearToken();
    _authController.logoff();
    //Return to login page:
    Navigator.pushReplacement(
      context, MaterialPageRoute(
        builder: (context) => const LoginView(),
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
            icon: Icon(Icons.logout),
            label:const Text("Log out"),
            onPressed: _HandleLogoff,
          )
        ],
      ),
      //Replace this with a layout that shows the user's chat list, and allows the user to select an active chat, or initiate one.
      //We also need to ensure the user is logged in and has a valid token.
      body:const Center(child: Text("\"Nothing but shadows and silence now,\" Garrett whispered after successfully picking the lock and sneaking inside.")
      )
    );
  }
}
