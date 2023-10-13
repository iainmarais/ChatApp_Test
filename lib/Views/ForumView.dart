// ignore_for_file: file_names, class_names, non_constant_identifier_names

//The forum view should show the user's active chats including group chats, similar to how a web forum displays its content.
//Possibly include set of subforums?

import 'package:flutter/material.dart';

import '../Utils/AuthManager.dart';


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
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title:const Text("Forum")
      ),
      body: const Center(
        child: Text("This is the forum. The idea for it is to be able to see users' discussions and be able to join one of them.")
      )
    );
  }
}
