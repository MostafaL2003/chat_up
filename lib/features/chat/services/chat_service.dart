import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendFriendRequest(String receiverUsername, String senderUsername, String senderImage) async {
    final senderUid = _auth.currentUser!.uid;

    final receiverDoc = await _db
        .collection('users')
        .where('username', isEqualTo: receiverUsername)
        .get();

    if (receiverDoc.docs.isEmpty) throw "User not found";
    final receiverUid = receiverDoc.docs.first.id;

    if (receiverUid == senderUid) throw "You cannot add yourself";


    final existingRequest = await _db
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
}