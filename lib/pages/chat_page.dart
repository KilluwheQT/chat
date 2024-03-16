import 'package:chat/components/chat_bubble.dart';
import 'package:chat/components/my_textfields.dart';
import 'package:chat/services/auth/auth_service.dart';
import 'package:chat/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  
   const ChatPage({super.key,
  required this.receiverEmail,
  required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //text controller
final TextEditingController _messageController = TextEditingController();

//chat auth service
final ChatServices _chatService = ChatServices();
final AuthService _authService = AuthService();

//textfield focus
FocusNode myFocusNode = FocusNode();

@override
void initState() {
  super.initState();

  //listener paras focus mode
  myFocusNode.addListener(() {
    if (myFocusNode.hasFocus){
        //delay for keyboard to pop up

      Future.delayed(const Duration(milliseconds: 500),
      () => scrollDown(),
      );
    }
  });

  //wait a bit for lsitview then scroll
  Future.delayed(
    const Duration(milliseconds: 500),
    () => scrollDown()
  );
}

@override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: 
    const Duration(seconds: 1), curve: Curves.fastOutSlowIn,);
  }


//send messgae
void sendMessage() async{
  if (_messageController.text.isNotEmpty) {
    await _chatService.sendMessage(widget.receiverID, _messageController.text);

    //clear text controller

    _messageController.clear();
  }

  scrollDown();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: Text(widget.receiverEmail),
      backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        ),
       
      body: Column(
        children: [
          Expanded(child: _buildMessageList(),
          ),

          //display all the messages

          //user input
          _buildUserInput(),

        ],),
    );
  }

        //build message list
        Widget _buildMessageList() {
          String senderID = _authService.getCurrentUser()!.uid;
          return StreamBuilder(
            stream: _chatService.getMessages(widget.receiverID, senderID),
            builder: (context, snapshot) {
                    //errors
                  if (snapshot.hasError) {
                    return const Text("Error");
                  }
                    //loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading...");
                  }
                    //return list view
                    return ListView(
                      controller: _scrollController,
                      children: 
                    snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
               
            );

            }
                        
            );
        }

        //build message item
        Widget _buildMessageItem(DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        //is current user   
        bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
        
        
        
        //alligh message to right
      var alignment = 
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

        return Container(
          alignment: alignment,
          child: Column(
            crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              ChatBubble(isCurrentUser: isCurrentUser, message: data["message"]),
            ],
          ));
        }

          //build message input
          Widget _buildUserInput() {
            return Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Row(
                children: [
                    Expanded(child: MyTextField(controller: _messageController,
                    hintText: "Type a message",
                    obscureText: false,
                    focusNode: myFocusNode,
                    ),
                    ),
              
                      //send button
                    Container(
                      decoration: const BoxDecoration(color: Colors.green,
                      shape: BoxShape.circle),
                      margin: const EdgeInsets.only(right: 25),
                      child: IconButton(onPressed: sendMessage, icon: const Icon(Icons.arrow_upward,
                      color: Colors.white),)),
                ],
              ),
            );
          }
}