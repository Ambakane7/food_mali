import 'package:flutter/material.dart';
import 'package:food_mali/model/cart_page.dart';

class MySliverApp extends StatelessWidget {
  final Widget child;
  final Widget title;
  MySliverApp({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text("Sunset Diner"),
      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      expandedHeight: 340,
      collapsedHeight: 130,
      floating: false,
      pinned: true,
      centerTitle: true,
      actions: [
        // cart button
        IconButton(onPressed: () {
          // go to cart page
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const CartPage()));
        },
            icon: const Icon(Icons.shopping_cart))
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: child,
        ),
        title: title,
        centerTitle: true,
        expandedTitleScale: 1,
        //background: Theme.of(context),
      ),
    );
  }
}
