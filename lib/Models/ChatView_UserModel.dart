// ignore_for_file: file_names, class_names, non_constant_identifier_names, camel_case_types

//Those who read my files, note the class name:
//As always, the file name matches the class name exactly. 
//It features a combination of Pascal case and an underscore to separate the type being represented from the class it is to be used in.
//Template of this is shown below:
//class TargetClassName_DataType - this makes more functional sense.
class ChatView_UserModel
{
  String? username;
  //This will be pulled in from the database.
  String? profileImageLink;
  bool? IsOnline; //Typically false for offline users, true for online users.
  ChatView_UserModel({this.username, this.profileImageLink, this.IsOnline});
}