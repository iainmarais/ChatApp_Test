// ignore_for_file: file_names, class_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

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
void showThemeDialog(context)
{
  showDialog(
    context: context,
    builder: (_) => ThemeConsumer(child: ThemeDialog())
  );
}
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

   void HandleLogoff() async
  {
    await _authManager.client!.auth.signOut();
  }

  @override
  Widget build(BuildContext context)
  {
    return ThemeConsumer(
      child: Builder(
        builder: (context) 
        {
          return Scaffold(
            appBar: AppBar(
              title:const Text("Main"),
              actions: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text("Change theme"),
                  onPressed: () => showThemeDialog(context),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label:const Text("Log out"),
                  onPressed: HandleLogoff,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit profile"),
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
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => showThemeDialog(context), 
                    icon: const Icon(Icons.color_lens),
                    label: const Text("Show theme selector"))
                ]
              ),
            )
          );
        }
      ),
    );
  }
}