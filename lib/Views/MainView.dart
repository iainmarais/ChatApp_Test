// ignore_for_file: file_names, class_names, non_constant_identifier_names
import 'dart:developer';

import 'package:flutter/material.dart';

import '../Controllers/ThemeController.dart';
import '../Utils/AuthManager.dart';
import 'ChatView.dart';
import 'ForumView.dart';
import 'UserProfileEditorView.dart';

class MainView extends StatefulWidget
{
  final AuthManager authManager;
  const MainView({required this.authManager,super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
{
get _authManager => widget.authManager;

  void _OpenChatView()
  {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ChatView(authManager: _authManager))
    );
  }

  void _OpenForumView()
  {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ForumView(authManager: _authManager))
    );
  }

  void SwapTheme()
  {
    log(ThemeController.currentTheme.toString());
    if (ThemeController.currentTheme==ThemeController.LightTheme)
    {
      ThemeController.SwitchToDarkTheme();
    }
    else
    {
      ThemeController.SwitchToLightTheme();
    }
  }

   void HandleLogoff() async
  {
    await _authManager.client!.auth.signOut();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Main"),
        actions: [
          TextButton(
            onPressed: SwapTheme,
            child: const Text("Switch theme")
            ),
          TextButton.icon(
            icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.onBackground,),
            label:Text("Log out", style: Theme.of(context).textTheme.labelLarge),
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
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to my app.", style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            Text("You can chat and post in the forum.", style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _OpenChatView,
              icon: const Icon(Icons.chat),
              label: const Text("Chat")
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _OpenForumView,
              icon: const Icon(Icons.forum),
              label: const Text("Forum")
            ),
          ]
        ),
      )
    );
  }
}