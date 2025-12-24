class UserModel {
  final String uid;
  final String username;
  final String imageUrl;

  UserModel({
    required this.username,
    required this.imageUrl,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'username': username, 'imageUrl': imageUrl};
  }
}
