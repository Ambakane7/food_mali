
import 'package:flutter/material.dart';


// food items
class Food {
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final FoodCategory category;
  final String restaurantName;

  List <Addon> avaibleAddons;

  Food(this.name, this.description, this.imagePath, this.price, this.category,this.avaibleAddons, this.restaurantName );

}

// food categories

enum FoodCategory{
  burgers,
  Special,
  KFC,
  Pizza,
  Gateau
}

// food menu
class Addon{
  String name;
  double price;
  Addon({required this.name, required this.price});
}