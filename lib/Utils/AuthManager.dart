// ignore_for_file: file_names, class_names, non_constant_identifier_names

//Makes sense from a logical standpoint to centralise this into one class - testing reveals all is working and supabase returns tokens
import "dart:async";
import "dart:developer";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:http/http.dart" as http;

class AuthManager
{
  final String host = "http://192.168.1.15:54321";
  final String anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0";
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager()
  { 
    return _instance;
  }
  AuthManager._internal();
  SupabaseClient? _client;

//Check the server state
  Future<bool> IsServerLive(Duration timeout) async
  {
    try
    {
      final response = await http.get(Uri.parse(host)).timeout(timeout);
      return response.statusCode == 200;
    }
    catch(ex)
    {
      return false;
    }
  }

  Future<void> initialiseSupabase() async
  {
    //Objectives:
    //Immediate Future: put these into a file so that they dont get pushed to github or any source sharing service in the clear.
    //Near Future objective: make these configurable
    //Deeper into the future: allow the user to specify their own backend provider. Vendor lock-in be damned!
    _client = SupabaseClient(host, anonKey);
  }
  void UpdateUserDetails({String? new_username, String? new_firstname, String? new_surname, String? new_about, String? new_profileImage, String? new_emailAddress}) async
  {
    //Can use this as a check to see if the table is present.
    try
    { 
      final chatUsers = await _client!.from("chat_users").select();
      if (chatUsers != null)
      {
        //See if an entry in the table exists for the user:
        var currentUser = await _client!.from("chat_users").select().eq("user_id", _client!.auth.currentUser!.id);
        if(currentUser.length > 0)
        {
          //This now correctly checks for a match in the table
          await _client!.from("chat_users").update({"user_id": _client!.auth.currentUser!.id,"username": new_username, "firstname": new_firstname, "surname": new_surname, "about": new_about, "profile_image": new_profileImage, "email_address": new_emailAddress}).eq("user_id", _client!.auth.currentUser!.id);
        }
        else
        {
          //If for whatever reason this entry is deleted from the table, this will create it: 
          //The exception being raised makes no sense, because the row is null. Don't raise the exception, create the row rather.
          await _client!.from("chat_users").insert({"user_id": _client!.auth.currentUser!.id,"username": new_username, "firstname": new_firstname, "surname": new_surname, "about": new_about, "profile_image": new_profileImage, "email_address": new_emailAddress}).eq("user_id", _client!.auth.currentUser!.id);
        }
      }
      else
      {
        //Create table via code not yet present in supabase-flutter lib. 
        //The table could not be located. Should try use a rest api call here, but for now it helps to log this to the console.
        log("Table not found. You must create it first.");
      }
    }
    catch(ex)
    {
      //Ok... So we know SOMETHING went wrong, so what is it? Go on, Spill it!
      log(ex.toString());
    }
  }
  //Retrieve user list:
  Future<List<dynamic>> RetrieveUserList() async
  {
    List<dynamic> UserList = await _client!.from("chat_users").select();
    if (UserList.isNotEmpty)
    {
      return UserList;
    }
    else
    {
      //Return empty list:
      return [];
    }
  }

  Future<String> GetUserName(String userId) async
  {
    final response = await _client!.from("chat_users").select().eq("user_id", userId);
    return response[0]["username"] as String;
  }
  Future<String> GetUserProfileImageLink(String userId) async
  {
    final response = await _client!.from("chat_users").select().eq("user_id", userId);
    return response[0]["profile_image"] as String;
  }

  void PostChatMessage(String content) async
  {
    final username = await GetUserName(_client!.auth.currentUser!.id);
    final userProfileImageLink = await GetUserProfileImageLink(_client!.auth.currentUser!.id);
    await _client!.from("chat_messages").insert({"created_at": DateTime.now().toIso8601String(), "sender_id": _client!.auth.currentUser!.id, "sender":username, "sender_profile_image":userProfileImageLink, "content": content});
  }
  Stream<List<dynamic>> RetrieveChatMessages()
  {
    final updateSubscription = _client!.from("chat_messages").stream(primaryKey: ["username"]);
    return updateSubscription;
  }

  SupabaseClient? get client => _client;
  SupabaseStorageClient? get storage => _client!.storage;

  //Add the token stream:
  Stream<String?> get tokenStream => _client!.auth.onAuthStateChange.map((data) => data.session?.accessToken);
  Stream<bool> CheckServerState(Duration timeout) async*
  {
    while(true)
    {
      final isServerLive = await IsServerLive(timeout);
      yield isServerLive;
      if (isServerLive)
      {
        break;
      }
      await Future.delayed(timeout);
    }
  }
}