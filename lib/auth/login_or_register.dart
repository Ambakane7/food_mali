import 'package:flutter/material.dart';
import 'package:food_mali/Pages/login_page.dart';
import 'package:food_mali/Pages/register.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: showLoginPage
          ? LoginPage(
        key: const ValueKey("login"),
        onTap: togglePages,
      )
          : RegisterPage(
        key: const ValueKey("register"),
        onTap: togglePages,
      ),
    );
  }
}