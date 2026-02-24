import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/login_or_register.dart';
import '../Pages/login_page.dart';
import '../model/cart_page.dart';
import '../model/restaurants.dart';
import 'my_drawer_tile.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  Map<String, dynamic>? userData;
  bool isLoading = false;

  // ================= FETCH USER =================
  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => isLoading = true);

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (mounted) {
      setState(() {
        userData = doc.data();
        isLoading = false;
      });
    }
  }

  // ================= UPDATE USER =================
  Future<void> _updateUserData(Map<String, dynamic> newData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update(newData);

    await _fetchUserData();

    if (newData.containsKey('address')) {
      Provider.of<Restaurants>(context, listen: false)
          .updateDeliveryAddress(newData['address']);
    }
  }

  // ================= DELETE ACCOUNT =================
  Future<void> _deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final orders = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .get();

      for (var doc in orders.docs) {
        await doc.reference.delete();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      await user.delete();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Veuillez vous reconnecter avant de supprimer votre compte.",
            ),
          ),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur lors de la suppression du compte."),
        ),
      );
    }
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Supprimer le compte"),
        content: const Text(
          "Cette action est définitive.\nVoulez-vous vraiment supprimer votre compte ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );
  }

  // ================= EDIT PROFILE =================
  void _showEditDialog() {
    final firstNameController =
    TextEditingController(text: userData?['firstName'] ?? '');
    final lastNameController =
    TextEditingController(text: userData?['lastName'] ?? '');
    final phoneController =
    TextEditingController(text: userData?['phone'] ?? '');
    final addressController =
    TextEditingController(text: userData?['address'] ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Modifier mes informations"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration:
                const InputDecoration(labelText: "Prénom"),
              ),
              TextField(
                controller: lastNameController,
                decoration:
                const InputDecoration(labelText: "Nom"),
              ),
              TextField(
                controller: phoneController,
                decoration:
                const InputDecoration(labelText: "Téléphone"),
              ),
              TextField(
                controller: addressController,
                decoration:
                const InputDecoration(labelText: "Adresse"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              _updateUserData({
                'firstName': firstNameController.text,
                'lastName': lastNameController.text,
                'phone': phoneController.text,
                'address': addressController.text,
              });
              Navigator.pop(context);
            },
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final firstName = userData?['firstName'] ?? '';
    final lastName = userData?['lastName'] ?? '';
    final email = userData?['email'] ?? '';
    final phone = userData?['phone'] ?? '';
    final address = userData?['address'] ?? '';

    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              if (isLoading) const LinearProgressIndicator(),

              // ================= INVITÉ =================
              if (user == null) ...[
                const SizedBox(height: 40),
                const Icon(Icons.person_outline,
                    size: 70, color: Colors.grey),
                const SizedBox(height: 15),
                const Text(
                  "Mode invité",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(45),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const LoginOrRegister(),
                        ),
                      );
                    },
                    child: const Text(
                      "Se connecter / Créer un compte",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const Divider(height: 40),
              ],

              // ================= CONNECTÉ =================
              if (user != null)
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor:
                          Theme.of(context).colorScheme.primary,
                          child: Text(
                            firstName.isNotEmpty
                                ? firstName[0].toUpperCase()
                                : "?",
                            style: const TextStyle(
                                fontSize: 30,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "$firstName $lastName",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        const SizedBox(height: 5),
                        Text(email,
                            style:
                            const TextStyle(color: Colors.grey)),
                        if (phone.isNotEmpty)
                          Text(phone,
                              style:
                              const TextStyle(color: Colors.grey)),
                        if (address.isNotEmpty)
                          Text(address,
                              textAlign: TextAlign.center,
                              style:
                              const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: _showEditDialog,
                          icon: const Icon(Icons.edit),
                          label: const Text("Modifier"),
                        )
                      ],
                    ),
                  ),
                ),

              const Divider(),

              // ================= MENU =================

              MyDrawerTile(
                text: "ACCUEIL",
                icon: Icons.home_outlined,
                ontTap: () => Navigator.pop(context),
              ),

              MyDrawerTile(
                text: "MON PANIER",
                icon: Icons.shopping_cart_outlined,
                ontTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CartPage()),
                  );
                },
              ),

              if (user != null)
                MyDrawerTile(
                  text: "SUPPRIMER MON COMPTE",
                  icon: Icons.delete_outline,
                  ontTap: _confirmDeleteAccount,
                ),

              if (user != null)
                MyDrawerTile(
                  text: "LOGOUT",
                  icon: Icons.logout_outlined,
                  ontTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!mounted) return;
                    Navigator.pop(context);
                    setState(() {
                      userData = null;
                    });
                  },
                ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}