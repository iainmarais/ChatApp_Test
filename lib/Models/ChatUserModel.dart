// ignore_for_file: file_names, class_names, non_constant_identifier_names

class ChatUserModel
{
  int? id; //Table entry id - serial, primary key
  String? userId; //UUID - references the value "id" in the auth->users table
  String? username;
  String? firstname;
  String? surname;
  String? about;
  String? profileImage;
  String? emailAddress;
  ChatUserModel({this.id, this.userId, this.username, this.firstname, this.surname, this.about, this.profileImage, this.emailAddress});

  factory ChatUserModel.fromMap(Map<String, dynamic> map)
  {
    return ChatUserModel(
      id: map["id"] as int?,
      userId: map["user_id"] as String?,
      username: map["username"] as String?,
      firstname: map["firstname"] as String?,
      surname: map["surname"] as String?,
      about: map["about"] as String?,
      profileImage: map["profileImage"] as String?,
      emailAddress: map["email_address"] as String?,
    );
  }
  Map<String, dynamic> toMap()
  {
    return {
      "id": id,
      "user_id": userId,
      "username": username,
      "firstname": firstname,
      "surname": surname,
      "about": about,
      "profile_image": profileImage,
      "email_address": emailAddress,
    };
  }
}