import 'package:chat/services/auth/auth_service.dart';
import 'package:chat/components/my_button.dart';
import 'package:chat/components/my_textfields.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatelessWidget {

      //email and pass controller
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _pwcontroller = TextEditingController();


    //togo to reg page
    final void Function()? onTap;

   LoginPage({super.key, required this.onTap});

   //login method
   void login(BuildContext context) async {
    // auth services
    final authService = AuthService();

    //try login
      try {
        await authService.signInWithEmailPassword(
          _emailcontroller.text,
          _pwcontroller.text,
        );
      }
    //catch any errors 
    catch (e) {
      showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(e.toString()),
      ),
      );
    }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        
          //logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
    

            const SizedBox(height: 50),

            //welcome back message
            Text("Welcome back, youv've been missed",
              style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),
            
            //email field
            MyTextField(
              hintText: "Email",
              obscureText: false,
              controller: _emailcontroller,
            ),
            
            const SizedBox(height: 10),

            //pw textfield
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: _pwcontroller,
            ),
            
            const SizedBox(height: 25),



            //login button

            MyButton(
              text: ("Login"),
              onTap: () => login(context),
            ),


           const SizedBox(height: 25),
            //register now
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Not a member?", 
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text("Register Now", style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary),)),
            ],
          )    
          ],
        ),
      ),
    );
  }
}