// ignore_for_file: file_names, class_names, non_constant_identifier_names
import "package:flutter/material.dart";
import "../Utils/AuthManager.dart";

class ChatMessage extends StatefulWidget 
{
  final AuthManager authManager;
  const ChatMessage({super.key, required this.authManager});

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
    _MessageController.clear();
    //just to be extra safe that the virtual keyboard is closed.
    Focus.of(context).unfocus();
  }
  void SubmitMessage()
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
  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.onPrimary,
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
                      style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                      controller: _MessageController,
                      decoration: const InputDecoration(
                        labelText: "Enter something..."
                      )
                    ),
                  ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed:SubmitMessage,
                  icon: const Icon(Icons.arrow_right_alt),
                  label: const Text("Send")
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