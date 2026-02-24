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
  final TextEditingController confirmpasswordController =
  TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? selectedAgeRange;
  String? selectedGender;
  bool acceptDataUsage = false;

  final List<String> ageRanges = [
    "Moins de 18 ans",
    "18 – 24 ans",
    "25 – 34 ans",
    "35 – 44 ans",
    "45 – 54 ans",
    "55 ans et plus",
  ];

  final List<String> genders = [
    "Homme",
    "Femme",
  ];

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
    final confirmPassword = confirmpasswordController.text.trim();

    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showError("Veuillez remplir les champs requis.");
      return false;
    }

    // Validation téléphone uniquement si rempli
    if (phone.isNotEmpty && !RegExp(r'^[0-9]{8}$').hasMatch(phone)) {
      showError("Le numéro doit contenir exactement 8 chiffres.");
      return false;
    }

    // Validation email uniquement si rempli
    if (email.isNotEmpty &&
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      showError("Adresse email invalide.");
      return false;
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

  String generateInternalEmail(String uid) {
    return "user_$uid@foodmali.app";
  }

  // ================= REGISTER =================
  void register() async {
    final authService = AuthService();
    if (!validateFields()) return;

    try {
      final userCredential = await authService.signUpWithEmailPassword(
        emailController.text.trim().isEmpty
            ? "temp_${DateTime.now().millisecondsSinceEpoch}@foodmali.app"
            : emailController.text.trim(),
        passwordController.text.trim(),
      );

      final uid = userCredential.user?.uid;

      if (uid != null) {
        String? phoneFull;

        if (phoneController.text.trim().isNotEmpty) {
          phoneFull =
          "+${selectedCountry.phoneCode}${phoneController.text.trim()}";
        }

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'firstName': firstNameController.text.trim(),
          'lastName': lastNameController.text.trim(),
          'phone': phoneFull,
          'email': emailController.text.trim().isEmpty
              ? null
              : emailController.text.trim(),
          'ageRange': selectedAgeRange,
          'gender': selectedGender,
          'dataConsent': acceptDataUsage,
          'orderCount': 0,
          'totalSpent': 0,
          'segment': 'new_user',
          'createdAt': Timestamp.now(),
        });
      }

      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("Inscription réussie"),
        ),
      );
    } catch (e) {
      showError("Erreur lors de l'inscription.");
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.2),
      body: SingleChildScrollView(
        child: Column(
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

            // TELEPHONE
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

            // GENRE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: const InputDecoration(
                  hintText: "Genre",
                  border: OutlineInputBorder(),
                ),
                items: genders
                    .map((g) =>
                    DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => selectedGender = value),
              ),
            ),

            const SizedBox(height: 10),

            // AGE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: DropdownButtonFormField<String>(
                value: selectedAgeRange,
                decoration: const InputDecoration(
                  hintText: "Tranche d'âge",
                  border: OutlineInputBorder(),
                ),
                items: ageRanges
                    .map((age) => DropdownMenuItem(
                  value: age,
                  child: Text(age),
                ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => selectedAgeRange = value),
              ),
            ),

            const SizedBox(height: 10),

            // PASSWORD
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

            // CONFIRM PASSWORD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: confirmpasswordController,
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
                      "J'accepte l'utilisation des données pour améliorer l'expérience FoodMali.",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            MyButton(text: "S'inscrire", onTap: register),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}