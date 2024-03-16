import 'package:chat/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ChatServices {
  //get instances of firestore
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('users');
 
  Future<QuerySnapshot> getUsers() {
    return _userCollection.get();
  }
  //get user stream
  /*
  
  List<Map<String,dynamic> = 
[
{
  'email': test@gmail.com,
  'id'
}

{
  'email': test1@gmail.com,
  'id'
}
]


*/

Stream<List<Map<String, dynamic>>> getUsersStream() {
  return _firestore
      .collection('Users').snapshots().map((snapshots){
        return snapshots.docs.map((doc) {
          //go through each individual user
        final user = doc.data();
        //return user
        return user;
        }).toList();
      });

}

  //send message
  Future<void> sendMessage(String receiverID, message) async {
    //get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    // create a new message
   Message newMessage = Message(
    senderID: currentUserID,
    senderEmail: currentUserEmail,
    receiverID: receiverID,
    message: message,
    timestamp: timestamp,

   );

    //chat room id for the two users
  List<String> ids = [currentUserID, receiverID];
  ids.sort();
  String chatRoomID = ids.join("_");

    //msg to db
      await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //get message
  Stream<QuerySnapshot> getMessages(String userId, otherUserID) {
    List<String> ids = [userId, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
    .collection("chat_rooms")
    .doc(chatRoomID).collection("messages")
    .orderBy("timestamp", descending: false)
    .snapshots();
  }

  
}