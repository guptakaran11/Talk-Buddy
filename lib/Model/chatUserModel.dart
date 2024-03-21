// ignore_for_file: public_member_api_docs, sort_constructors_first, file_names
class ChatUserModel {
  final String uid;
  final String name;
  final String email;
  final String imageURl;
  late DateTime lastActive;
  ChatUserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageURl,
    required this.lastActive,
  });

  factory ChatUserModel.fromJSON(Map<String, dynamic> json) {
    return ChatUserModel(
      uid: json["uid"],
      name: json["name"],
      email: json['email'],
      imageURl: json["image"],
      lastActive: json["last_active"].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "name": name,
      "last_active": lastActive,
      "image": imageURl
    };
  }

  String lastDayActive() {
    return "${lastActive.day}/${lastActive.month}/${lastActive.year}";
  }

  bool wasRecentlyActive() {
    return DateTime.now().difference(lastActive).inHours < 2;
  }
}
