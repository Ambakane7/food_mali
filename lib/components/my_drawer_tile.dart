import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final String text;
  final IconData? icon;
  final void Function()? ontTap;
  MyDrawerTile({super.key, required this.text, this.icon, this.ontTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold, fontSize: 12),
        ),
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        onTap: ontTap,
      ),
    );
  }
}
