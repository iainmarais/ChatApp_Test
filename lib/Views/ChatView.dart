// ignore_for_file: file_names, class_names, non_constant_identifier_names

//This will serve as the entry point for an active chat session. These details will have to be retrieved from the backend.

import "dart:io";

import "package:app02/Widgets/ChatMessage.dart";
import "package:app02/Widgets/ChatMessageList.dart";
import "package:flutter/material.dart";
import "../Utils/AuthManager.dart";
import "./UserProfileEditorView.dart";
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

  //Does what it says on the tin. Log off the current user.
  //Supabase backend tells the frontend the user is not logged in so the frontend automatically returns to the login page.
  //Any programmer building their own backend might ask what sorcery is this
  void HandleLogoff() async
  {
    await widget.authManager.client!.auth.signOut();
    if(!context.mounted)
    {
      return;
    }
    Navigator.of(context).pop();
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
            icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.onBackground),
            label:Text("Log out", style: Theme.of(context).textTheme.labelLarge),
            //Need to fix this so that the supabase token is cleared when the user logs out, and return to the login page.
            onPressed: HandleLogoff,
            ),
            TextButton.icon(
              onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfileEditorView(authManager: authManager)
                  )
                );
              },
              icon: Icon(Icons.edit,color: Theme.of(context).colorScheme.onBackground),
              label: Text("Edit profile",style: Theme.of(context).textTheme.labelLarge))
          ],
        ),
      body: Center(
        child: Row(
          children: [
            Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Column(
               children: [
                Expanded(child: ChatMessageList(authManager: authManager)),
                ChatMessage(authManager: authManager,),
                ] 
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: FutureBuilder(
                future: authManager.RetrieveUserList() as Future<List<dynamic>>, 
                builder: (context,snapshot)
                {
                  if(snapshot.data != null)
                  {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index)
                      {
                        return ListTile(
                          tileColor: Theme.of(context).colorScheme.primaryContainer,
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration:BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: snapshot.data![index]["profile_image"] == null
                                ? FileImage(File("images/avatars-src/placeholder-default.png")) as ImageProvider
                                : NetworkImage(snapshot.data![index]["profile_image"])
                              )
                            )
                          ),
                          title: Text(snapshot.data![index]["username"] ?? "") ,
                          subtitle: Text(snapshot.data![index]["email_address"]?? ""), 
                        );
                      }
                    );
                  }
                  else
                  {
                    return const Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20.0),
                        Text("Waiting for connection...")
                      ],
                    );
                  }
                }
              )
            )
          ],
        )
      )
    );
  }
}
