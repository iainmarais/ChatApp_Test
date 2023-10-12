// ignore_for_file: file_names, class_names, non_constant_identifier_names

//To programmers who would whine about style, just bear in mind:
//I maintain a consistent style with C#, and employ this here as well.
//Rigidly enforcing conventions stifles creativity. Instead of forcing down a fixed style on app developers, embrace their diversity of style.
//If someone wants to write dart code that resembles python, let them. The same is true for a C# or Rust developer who wants to use their style.

//Remember that real diversity is our strength!

//Project notes:
//Login and registration: working with supabase backend.
//User profile management: Still to be done.
//Main views: chat, forum and conversations: Still to be done.
//Current self-assessment: So far the code does what it is meant to, and in general is looking decent. Needs work in some areas.

import "package:flutter/material.dart";

//Our app namespaces here:
import "./Views/LoginView.dart";
import "./Views/MainView.dart";
import "./Utils/AuthManager.dart";
import "./Views/LoadScreen.dart";

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  final authManager = AuthManager();
  await authManager.initialiseSupabase();
  final isServerLive = await authManager.IsServerLive(const Duration(seconds:5));
  runApp(ChatApp(authManager: authManager, isServerLive: isServerLive));
  debugDumpRenderTree();
}

//Entry point class for this app:
class ChatApp extends StatelessWidget 
{
  final bool isServerLive;
  final AuthManager authManager;
  const ChatApp({super.key, required this.authManager, required this.isServerLive});
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
       home:  isServerLive ? 
       LoadScreen(authManager: authManager)
       :StreamBuilder(
              stream: authManager.tokenStream,
              builder: (context, snapshot) 
              {
                  if (snapshot.hasData) 
                  {
                    return MainView(authManager:authManager);
                  } 
                  else 
                  {
                    return LoginView(authManager:authManager);
                  }
              }
            )
          
       );
  }
}