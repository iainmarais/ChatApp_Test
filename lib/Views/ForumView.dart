// ignore_for_file: file_names, class_names, non_constant_identifier_names

//The forum view should show the user's active chats including group chats, similar to how a web forum displays its content.
//Possibly include set of subforums?

import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

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

  void showThemeDialog(context)
  {
    showDialog(
      context: context,
      builder: (_) => ThemeConsumer(child: ThemeDialog())
    );
  }

  void HandleLogoff() async
  {
    await _authManager.client!.auth.signOut();
    if(!context.mounted)
    {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context)
  {
    return ThemeConsumer(
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title:const Text("Forum"),
              actions: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text("Change theme"),
                  onPressed: () => showThemeDialog(context),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label:const Text("Log out"),
                  //Need to fix this so that the supabase token is cleared when the user logs out, and return to the login page.
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
                  ]
            ),
            //Title column: This column contains a number of subtitles and a title set to the name of the category.
            body: const Column(
              children: [
                Flexible(
                  //Can also use a list view builder to return the name of the active discussion and its appropriate column names.
                  flex: 1,
                  child: ListTile(
                    title:Text("This is a placeholder for the actual discussion title or category name."),
                    subtitle: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          children: [
                            Text("Topic"),
                          ]
                        ),
                        Column(
                          children: [
                            Text("Views")
                          ]
                        ),
                        Column(
                          children: [
                            Text("Replies")
                          ]
                        ),
                        Column(
                          children: [
                            Text("Last post")
                          ]
                        ),
                        Column(
                          children: [
                            Text("Started by")
                          ]
                        )
                      ]
                    )
                  )
                ),
                Flexible(
                  //Use a list view builder here.
                  child: ListTile(
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                Text("Assassin's Creed series"),
                              ],
                            ),
                            Column(
                              children: [
                                Text("100"),
                              ],
                            ),
                            Column(
                              children: [
                                Text("24"),
                              ],
                            ),
                            Column(
                              children: [
                                Text("3 days ago"),
                              ],
                            ),
                            Column(
                              children: [
                                Text("<starter's username>"),
                              ],
                            )
                          ]
                        ),
                      ]
                    ),
                  ),
                )
              ],
            )
          );
        }
      ),
    );
  }
}
