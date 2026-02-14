import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Pages/login_page.dart';
import '../model/restaurants.dart';
import 'my_drawer_tile.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  Map<String, dynamic>? userData;

  // ================= FETCH USER =================
  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        userData = doc.data();
      });
    }
  }

  // ================= UPDATE USER =================
  Future<void> _updateUserData(Map<String, dynamic> newData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
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
  }

  // ================= DELETE ACCOUNT =================
  Future<void> _deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Supprimer les commandes
      final orders = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .get();

      for (var doc in orders.docs) {
        await doc.reference.delete();
      }

      // Supprimer document user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      // Supprimer compte auth
      await user.delete();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
            (route) => false,
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Veuillez vous reconnecter avant de supprimer votre compte."),
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
            "Cette action est définitive.\nVoulez-vous vraiment supprimer votre compte ?"),
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

  // ================= EDIT DIALOG =================
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
                decoration: const InputDecoration(labelText: "Prénom"),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: "Nom"),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Téléphone"),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Adresse"),
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
    final firstName = userData?['firstName'] ?? '';
    final lastName = userData?['lastName'] ?? '';
    final email = userData?['email'] ?? '';
    final phone = userData?['phone'] ?? '';
    final address = userData?['address'] ?? '';

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                              fontSize: 30, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "$firstName $lastName",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      Text(email,
                          style: const TextStyle(color: Colors.grey)),
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

              MyDrawerTile(
                text: "ACCUEIL",
                icon: Icons.home_outlined,
                ontTap: () => Navigator.pop(context),
              ),

              MyDrawerTile(
                text: "ADRESSE DE LIVRAISON",
                icon: Icons.location_on_outlined,
                ontTap: _showEditDialog,
              ),

              MyDrawerTile(
                text: "SUPPRIMER MON COMPTE",
                icon: Icons.delete_outline,
                ontTap: _confirmDeleteAccount,
              ),

              MyDrawerTile(
                text: "LOGOUT",
                icon: Icons.logout_outlined,
                ontTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (!mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                        (route) => false,
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
