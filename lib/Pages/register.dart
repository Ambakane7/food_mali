import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/auth_service.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool acceptDataUsage = false;
  bool _isLoading = false;

  Country selectedCountry = Country(
    phoneCode: '223',
    countryCode: 'ML',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Mali',
    example: '650123456',
    displayName: 'Mali',
    displayNameNoCountryCode: 'Mali',
    e164Key: '',
  );

  void showError(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Erreur"),
        content: Text(message),
      ),
    );
  }

  bool validateFields() {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showError("Champs obligatoires manquants");
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      showError("Les mots de passe ne correspondent pas");
      return false;
    }

    if (!acceptDataUsage) {
      showError("Veuillez accepter les conditions");
      return false;
    }

    return true;
  }

  Future<void> register() async {
    if (!validateFields()) return;

    setState(() => _isLoading = true);

    try {
      final auth = AuthService();

      final credential = await auth.signUpWithEmailPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final uid = credential.user?.uid;

      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'firstName': firstNameController.text.trim(),
          'lastName': lastNameController.text.trim(),
          'email': emailController.text.trim(),
          'role': 'user',
          'createdAt': Timestamp.now(),
        });
      }

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
    } catch (e) {
      showError("Erreur lors de l'inscription");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // ✅ correction ici
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("lib/images/Login.json"),
            const SizedBox(height: 10),

            MyTextfield(
              controller: firstNameController,
              hintext: "Prénom",
              obscureText: false,
            ),

            const SizedBox(height: 10),

            MyTextfield(
              controller: lastNameController,
              hintext: "Nom",
              obscureText: false,
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.tertiary),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        countryListTheme:
                        const CountryListThemeData(bottomSheetHeight: 550),
                        onSelect: (Country country) {
                          setState(() => selectedCountry = country);
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Text("+${selectedCountry.phoneCode}"),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 8,
                      decoration: const InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                        hintText: "Téléphone",
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 10),

            MyTextfield(
              controller: emailController,
              hintext: "Email",
              obscureText: false,
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: "Mot de passe",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: "Confirmer le mot de passe",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword =
                        !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Checkbox(
                    value: acceptDataUsage,
                    onChanged: (value) {
                      setState(() {
                        acceptDataUsage = value ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      "J'accepte que mes données soient utilisées pour améliorer l'expérience FoodMali.",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _isLoading
                ? const CircularProgressIndicator()
                : MyButton(text: "S'inscrire", onTap: register),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}