import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendFriendRequest(
    String receiverUsername,
    String senderUsername,
    String senderImage,
  ) async {
    final senderUid = _auth.currentUser!.uid;

    final receiverDoc =
        await _db
            .collection('users')
            .where('username', isEqualTo: receiverUsername)
            .get();

    if (receiverDoc.docs.isEmpty) throw "User not found";
    final receiverUid = receiverDoc.docs.first.id;

    if (receiverUid == senderUid) throw "You cannot add yourself";

    final existingRequest =
        await _db
            .collection('friend_requests')
            .where('senderId', isEqualTo: senderUid)
            .where('receiverId', isEqualTo: receiverUid)
            .where('status', isEqualTo: 'pending')
            .get();

    if (existingRequest.docs.isNotEmpty) throw "Request already sent";

    await _db.collection('friend_requests').add({
      'senderId': senderUid,
      'senderUsername': senderUsername,
      'senderImageUrl': senderImage,
      'receiverId': receiverUid,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getFriendRequests() {
    final currentUid = _auth.currentUser!.uid;
    return _db
        .collection('friend_requests')
        .where('receiverId', isEqualTo: currentUid)
        .snapshots();
  }

  Future<void> declineFriendRequest(String requestId) async {
    await _db.collection('friend_requests').doc(requestId).delete();
  }

  Future<void> acceptFriendRequest(String requestId, String senderUid) async {
    final currentUid = _auth.currentUser!.uid;

    await _db
        .collection('users')
        .doc(currentUid)
        .collection('friends')
        .doc(senderUid)
        .set({'uid': senderUid, 'timestamp': FieldValue.serverTimestamp()});

    await _db
        .collection('users')
        .doc(senderUid)
        .collection('friends')
        .doc(currentUid)
        .set({'uid': currentUid, 'timestamp': FieldValue.serverTimestamp()});

    await _db.collection('friend_requests').doc(requestId).delete();
  }

  Stream<QuerySnapshot> getFriendsStream() {
    final currentUid = _auth.currentUser!.uid;
    return _db
        .collection('users')
        .doc(currentUid)
        .collection('friends')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  String getChatRoomId(String userA, String userB) {
    List<String> ids = [userA, userB];
    ids.sort();
    return ids.join("_");
  }

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    String chatRoomId = getChatRoomId(currentUserId, receiverId);

    await _db
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
          'senderId': currentUserId,
          'receiverId': receiverId,
          'message': message,
          'timestamp': timestamp,
        });

    final Map<String, dynamic> friendUpdateData = {
      'lastMessage': message,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _db
        .collection('users')
        .doc(currentUserId)
        .collection('friends')
        .doc(receiverId)
        .set(friendUpdateData, SetOptions(merge: true));

    await _db
        .collection('users')
        .doc(receiverId)
        .collection('friends')
        .doc(currentUserId)
        .set(friendUpdateData, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    String chatRoomId = getChatRoomId(userId, otherUserId);

    return _db
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
