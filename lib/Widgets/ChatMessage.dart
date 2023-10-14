// ignore_for_file: file_names, class_names, non_constant_identifier_names
import "dart:developer";

import "package:flutter/material.dart";
import "../Utils/AuthManager.dart";

class ChatMessage extends StatefulWidget 
{
  final AuthManager authManager;
  final Theme? theme;
  const ChatMessage({super.key, required this.authManager, this.theme});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> 
{
  get _authManager => widget.authManager;
  final _MessageController = TextEditingController();
  @override
  void dispose()
  {
    _MessageController.dispose();
    super.dispose();
  }

  void ClearMessage()
  {
    try
    {
      final message = _MessageController.text;
      if(message.isNotEmpty)
      {
        _MessageController.clear();
        //just to be extra safe that the virtual keyboard is closed.
        Focus.of(context).unfocus();
      }
      else
      {
        return;
      }
    }
    //Just to deal with the case where there is no virtual keyboard to hide
    catch(ex)
    {
      log(ex.toString());
    }
  }
  void SubmitMessage()
  {
    try
    {
      final message = _MessageController.text;
      if(message.isNotEmpty)
      {
        _authManager.PostChatMessage(message);
        _MessageController.clear();
        //Definitely need to close it here:
        Focus.of(context).unfocus();
      }
      else
      {
        return;
      }
    }
    //Just to deal with the case where there is no virtual keyboard to hide
    catch(ex)
    {
      log(ex.toString());
    }
  }
  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Constraining these should be done behind the scenes. 
                //If the layout is not defined, create it automatically and do it behind the scenes.
                  Expanded(
                    child: TextField(
                      controller: _MessageController,
                      decoration: const InputDecoration(
                        labelText: "Enter something...",
                      )
                    ),
                  ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed:SubmitMessage,
                  icon:  const Icon(Icons.arrow_right_alt),
                  label: const Text("Send"),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed:ClearMessage, 
                  icon: const Icon(Icons.clear),
                  label: const Text("Clear")
                )
              ]
            ),
          ],
        ),
      ),
    );
  }
}