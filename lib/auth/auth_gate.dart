import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_mali/Accueil/Page1.dart';
import 'package:food_mali/Pages/home_page.dart';
import 'package:food_mali/auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            // user is logged in
            if (snapshot.hasData){
              return Page1();
            }
            // user is not logged in
            else{
              return const LoginOrRegister();
            }

          }),
    );
  }
}
