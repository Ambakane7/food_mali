import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'newpasswordscreen.dart';


class OTPScreen extends StatefulWidget {
  final String verificationId;
  const OTPScreen({super.key, required this.verificationId});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _otpController = TextEditingController();
  bool isLoading = false;

  void verifyOTP() async {
    String smsCode = _otpController.text.trim();
    if (smsCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer le code OTP")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Création du credential avec le code OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );

      // Connexion de l'utilisateur
      await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() => isLoading = false);

      // 🔹 Redirection automatique vers la page de nouveau mot de passe
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NewPasswordScreen()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Téléphone vérifié ! Créez un nouveau mot de passe.")),
      );

    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${e.message}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Entrer le code OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Code OTP",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : verifyOTP,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Vérifier le code"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
