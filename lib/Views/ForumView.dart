// ignore_for_file: file_names, class_names, non_constant_identifier_names

//The forum view should show the user's active chats including group chats, similar to how a web forum displays its content.
//Possibly include set of subforums?

import 'package:flutter/material.dart';

class ForumView extends StatefulWidget
{
  const ForumView({Key? key}) : super(key: key);

  @override
  State<ForumView> createState() => _ForumViewState();
}
class _ForumViewState extends State<ForumView>
{
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
