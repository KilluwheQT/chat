import 'package:chat/services/auth/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../pages/home_page.dart';

class Authgate extends StatelessWidget {
  const Authgate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
         // user log in
        if (snapshot.hasData) {
          return  HomePage();
        }


        
         //user is not log in

         else {
          return const LoginOrRegister();
         }
        },
      ),
    );
  }
}