// ignore_for_file: file_names, class_names, non_constant_identifier_names

//To programmers who would whine about style, just bear in mind:
//I maintain a consistent style with C#, and employ this here as well.
//Rigidly enforcing conventions stifles creativity. Instead of forcing down a fixed style on app developers, embrace their diversity of style.
//If someone wants to write dart code that resembles python, let them. The same is true for a C# or Rust developer who wants to use their style.

//Remeber that real diversity is our strength!

import "package:flutter/material.dart";
//Our app namespaces here:
import "./Views/LoginView.dart";
import "./Views/ChatView.dart";

void main() 
{
  runApp(const ChatApp());
}


//Entry point class for this app:
class ChatApp extends StatelessWidget 
{
  const ChatApp({Key? key}) : super(key: key);
  //Create a theme that can be used globally:
  static get darkTheme => ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 45, 20, 102), brightness: Brightness.dark)
  );
  static get lightTheme => ThemeData(
    brightness: Brightness.light,
    //use a seed colour value around a dark purple:
    colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 45, 20, 102), brightness: Brightness.light)
  );


  @override
  Widget build(BuildContext context) 
  {
    return  MaterialApp(
      title: "Chat",
      theme: darkTheme,
      home: StreamBuilder(
        //Check if the user is logged in:
        stream: authStream, 
        builder: (context, snapshot)
        {
          if(snapshot.connectionState == ConnectionState.active)
          {
            final bool IsAuthenticated = snapshot.data != null &&  snapshot.data!.IsAuthenticated;
            //Create a new main view that can be used to open up any active chats, or visit the users' open chat forum
            return IsAuthenticated ? const ChatView() : const LoginView();
          }
          else
          {
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                title:const Text("Authenticating...")
              ),
              body: const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text("Checking authentication state...")
                  ],
                ),
              ),
            );
          }
        }
      ),
    );
  }
}