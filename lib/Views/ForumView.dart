// ignore_for_file: file_names, class_names, non_constant_identifier_names

//The forum view should show the user's active chats including group chats, similar to how a web forum displays its content.
//Possibly include set of subforums?

import 'package:flutter/material.dart';

import '../Utils/AuthManager.dart';
import 'UserProfileEditorView.dart';


class ForumView extends StatefulWidget
{
  final AuthManager authManager;
  const ForumView({required this.authManager,super.key});

  @override
  State<ForumView> createState() => _ForumViewState();
}
class _ForumViewState extends State<ForumView>
{
  get _authManager => widget.authManager;

  void HandleLogoff() async
  {
    await _authManager.client!.auth.signOut();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title:const Text("Forum"),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.onBackground),
            label:Text("Log out", style: Theme.of(context).textTheme.labelLarge),
            //Need to fix this so that the supabase token is cleared when the user logs out, and return to the login page.
            onPressed: HandleLogoff,
            ),
            TextButton.icon(
            icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.onBackground,),
            label: Text("Edit profile",style: Theme.of(context).textTheme.labelLarge),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfileEditorView(authManager: _authManager)
                )
              );
            },
          )
            ]
      ),
      body: const Center(
        child: Text("This is the forum. The idea for it is to be able to see users' discussions and be able to join one of them.")
      )
    );
  }
}
