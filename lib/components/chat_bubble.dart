import 'package:chat/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  
  
  const ChatBubble({super.key, 
  required this.isCurrentUser,
  required this.message,});

  @override
  Widget build(BuildContext context) {
      //light vs dark 
      bool isDarkMode =
      Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Container(
        decoration: BoxDecoration(
          color: isCurrentUser ?
          (isDarkMode? Colors.green.shade600: Colors.grey.shade500) : 
           (isDarkMode? Colors.grey.shade800: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 25),
      child: Text(message,
      style:  TextStyle(color: isCurrentUser
      ?  Colors.white 
      : (isDarkMode? const Color.fromARGB(255, 255, 255, 255): Colors.black)),
    ),
    );
  }
}