// ignore_for_file: file_names, class_names, non_constant_identifier_names

import "dart:developer";

import "package:flutter/material.dart";
import "../Utils/AuthManager.dart";

class ChatMessageList extends StatefulWidget
{
  final AuthManager authManager;
  final Theme? theme;
  const ChatMessageList({super.key, required this.authManager, this.theme});
  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}
//Periodically refresh this? Or how else can I update this in realtime...
class _ChatMessageListState extends State<ChatMessageList> 
{
  get _authManager => widget.authManager;
  @override
  Widget build(BuildContext context)
  {
    return Center(
      child: StreamBuilder(
        stream: _authManager.RetrieveChatMessages() as Stream<List<Map<String, dynamic>>>,
        builder:(context, snapshot)
        {
          log(snapshot.data.toString());
          if(snapshot.data != null && snapshot.data!.isNotEmpty)
          {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index)
              {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    //Create a chat message widget for each message found in the database.
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data![index]["sender_profile_image"]
                        )
                      ),
                    ),
                    ),
                    title: Text(snapshot.data![index]["sender"] ?? ""), 
                    subtitle: Text(snapshot.data![index]["content"] ?? ""),
                  ),
                );
              }
            );
          }
          else
          {
            return const Center(
              child: Text("Blimey! You've got no messages, mate!"),
            );
          }
        }
      )
    );
  }
}