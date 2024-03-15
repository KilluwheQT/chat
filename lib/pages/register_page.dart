import 'package:chat/services/auth/auth_service.dart';
import 'package:flutter/material.dart';


import '../components/my_button.dart';
import '../components/my_textfields.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _pwcontroller = TextEditingController();
  final TextEditingController _confirmPwcontroller = TextEditingController();

  final void Function()? ontap;

  RegisterPage({super.key, required this.ontap});

  //register method
   void register(BuildContext context) {
    //get auth service
    final _auth = AuthService();

    //password match
    if (_pwcontroller.text == _confirmPwcontroller.text) {
      try {
        _auth.signUpWithEmailAndPassword(
          _emailcontroller.text,
          _pwcontroller.text
          );
      } catch(e) {
        showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(e.toString()),
      ),
      );
      }
    }
      // if pw dont match error
    else {
      showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text("Password dont match!"),
      ),
      );
    }
   }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      backgroundColor: Color.fromARGB(255, 231, 176, 212),
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
            Text("Lets create an account for you",
              style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
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

            const SizedBox(height: 10),

            //confrimpw textfield
            MyTextField(
              hintText: "Confirm Password",
              obscureText: true,
              controller: _confirmPwcontroller,
            ),
            
            const SizedBox(height: 25),



            //login button

            MyButton(
              text: ("Register"),
              onTap: () => register(context),
            ),


           const SizedBox(height: 25),
            //register now
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account?", 
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              GestureDetector(
                onTap: ontap,
                child: Text("Login Now", style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary),)),
            ],
          )    
          ],
        ),
      ),
    );
  }
}