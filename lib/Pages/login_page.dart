import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  bool _obscurePassword = true;

  // ===== NORMALISATION NUMERO =====
  String normalizePhone(String input) {
    String phone = input.trim();

    // Supprime espaces
    phone = phone.replaceAll(" ", "");

    // Si commence par 0
    if (phone.startsWith("0")) {
      phone = phone.substring(1);
    }

    // Si pas de +223
    if (!phone.startsWith("+")) {
      phone = "+223$phone";
    }

    return phone;
  }

  // ===== LOGIN =====
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
      // ===== CAS NUMERO =====
      else {
        final normalizedPhone = normalizePhone(identifier);

        final doc = await FirebaseFirestore.instance
            .collection('phone_lookup')
            .doc(normalizedPhone)
            .get();

        if (!doc.exists) {
          showError("Aucun compte associé à ce numéro.");
          return;
        }

        emailToUse = doc['email'];
      }

      await _authService.signInWithEmailPassword(
        emailToUse,
        password,
      );

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        "/",
            (route) => false,
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

            MyTextfield(
              controller: identifierController,
              hintext: "Email ou numéro de téléphone",
              obscureText: false,
            ),

            const SizedBox(height: 10),

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

            MyButton(
              text: "Se connecter",
              onTap: login,
            ),

            const SizedBox(height: 15),

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