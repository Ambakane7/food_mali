import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:food_mali/auth/auth_service.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

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

  // ================= VALIDATION =================
  bool validateFields() {
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showError("Veuillez remplir tous les champs obligatoires.");
      return false;
    }

    // Email obligatoire
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      showError("Adresse email invalide.");
      return false;
    }

    // Téléphone OPTIONNEL mais valide si rempli
    if (phone.isNotEmpty) {
      if (!RegExp(r'^[0-9]{8}$').hasMatch(phone)) {
        showError("Le numéro doit contenir exactement 8 chiffres.");
        return false;
      }
    }

    if (password != confirmPassword) {
      showError("Les mots de passe ne correspondent pas.");
      return false;
    }

    if (!acceptDataUsage) {
      showError(
          "Vous devez accepter l'utilisation des données pour continuer.");
      return false;
    }

    return true;
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Erreur"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  // ================= REGISTER =================
  Future<void> register() async {
    if (!validateFields()) return;

    setState(() => _isLoading = true);

    final authService = AuthService();
    final phone = phoneController.text.trim();

    String? phoneFull;

    if (phone.isNotEmpty) {
      phoneFull = "+${selectedCountry.phoneCode}$phone";
    }

    try {
      final userCredential = await authService.signUpWithEmailPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final uid = userCredential.user?.uid;

      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'firstName': firstNameController.text.trim(),
          'lastName': lastNameController.text.trim(),
          'email': emailController.text.trim(),
          'role': 'user',
          'dataConsent': acceptDataUsage,
          'orderCount': 0,
          'totalSpent': 0,
          'segment': 'new_user',
          'createdAt': Timestamp.now(),
          if (phoneFull != null) 'phone': phoneFull,
        });

        // 🔥 ENREGISTREMENT DANS PHONE_LOOKUP
        if (phoneFull != null) {
          await FirebaseFirestore.instance
              .collection('phone_lookup')
              .doc(phoneFull)
              .set({
            'email': emailController.text.trim(),
          });
        }
      }

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        "/",
            (route) => false,
      );

    } catch (e) {
      showError("Erreur lors de l'inscription.");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.2),
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

            // ===== TELEPHONE OPTIONNEL =====
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