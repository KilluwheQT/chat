import 'package:chat/pages/chat_page.dart';
import 'package:chat/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
import '../components/user_tile.dart';
import '../services/auth/auth_service.dart';
import '../components/my_drawer.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});

  //caht and auth services
  final ChatServices _chatService = ChatServices();
  final AuthService _authService = AuthService();
  
  void logout() {
    //get auth service
    final auth = AuthService();
    auth.signOut();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home",),
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }
    // build a list of users except for the current logged in user

    Widget _buildUserList() {
      return StreamBuilder(
        stream: _chatService.getUsersStream(),
        builder: (context, snapshot) {
          //error
        if (snapshot.hasError) {
          return const Text("Eroor");
        }
          //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
          //return list view
        return ListView(
          children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData, context)).toList(),
        );

        }
      );
    }

    //build building  each item in the list of user
    Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context){
      //display all users except current user
      if (userData["email"] !=_authService.getCurrentUser()!.email) {
        return UserTile(
        text: userData["email"],
        onTap: () {

            //tapped on a user -> go to chat page
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
              receiverEmail: userData["email"],
            ),
             ));

        },
      );
      }else {
        return Container();
      }
    }

}