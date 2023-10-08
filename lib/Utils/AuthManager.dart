// ignore_for_file: file_names, class_names, non_constant_identifier_names

//Makes sense from a logical standpoint to centralise this into one class - testing reveals all is working and supabase returns tokens
import "dart:async";

import "package:supabase_flutter/supabase_flutter.dart";
class AuthManager
{
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager()
  { 
    return _instance;
  }
  AuthManager._internal();
  SupabaseClient? _client;
  SupabaseStorageClient? _storage;

  Future<void> initialiseSupabase() async
  {
    //Objectives:
    //Immediate Future: put these into a file so that they dont get pushed to github or any source sharing service in the clear.
    //Near Future objective: make these configurable
    //Deeper into the future: allow the user to specify their own backend provider. Vendor lock-in be damned!
    final host = "http://192.168.1.15:54321";
    final anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0";
    _client = SupabaseClient(host, anonKey);
  }
  SupabaseClient? get client => _client;
  SupabaseStorageClient? get storage => _storage;

  //Add the token stream:
  Stream<String?> get tokenStream => _client!.auth.onAuthStateChange.map((data) => data.session?.accessToken);
}