import 'package:flutter/material.dart';
import 'package:food_mali/Accueil/Page1.dart';
import 'package:lottie/lottie.dart';

import '../auth/auth_service.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  // ✅ AJOUT : contrôle visibilité mot de passe
  bool _obscurePassword = true;

  // ===== CONVERT PHONE TO EMAIL (INTERNE) =====
  String phoneToEmail(String phone) {
    return "$phone@foodmali.app";
  }

  // ===== LOGIN METHOD =====
  Future<void> login() async {
    final identifier = identifierController.text.trim();
    final password = passwordController.text.trim();

    if (identifier.isEmpty || password.isEmpty) {
      showError("Veuillez remplir tous les champs.");
      return;
    }

    try {
      String emailToUse;

      // ===== CAS EMAIL =====
      if (identifier.contains('@')) {
        emailToUse = identifier;
      }
      // ===== CAS TELEPHONE =====
      else {
        final phone = identifier.startsWith('+')
            ? identifier
            : '+223$identifier';

        final email = await _authService.getEmailFromPhone(phone);

        if (email == null) {
          showError("Aucun compte associé à ce numéro.");
          return;
        }

        emailToUse = email;
      }

      await _authService.signInWithEmailPassword(
        emailToUse,
        password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Page1()),
      );
    } catch (e) {
      showError("Identifiants incorrects.");
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Erreur"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    identifierController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ===== UI =====
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.2),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("lib/images/contact.json"),

            const SizedBox(height: 10),

            const Text(
              "FoodMali App",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 25),

            // ===== IDENTIFIER =====
            MyTextfield(
              controller: identifierController,
              hintext: "Email ou numéro de téléphone",
              obscureText: false,
            ),

            const SizedBox(height: 10),

            // ===== PASSWORD AVEC VISIBILITÉ =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: "Mot de passe",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ===== LOGIN BUTTON =====
            MyButton(
              text: "Se connecter",
              onTap: login,
            ),

            const SizedBox(height: 15),

            // ===== REGISTER =====
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Pas de compte ? ",
                  style: TextStyle(color: Colors.black),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    "Créer un compte",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
