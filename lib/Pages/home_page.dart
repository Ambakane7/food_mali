import 'dart:core';

import 'package:flutter/material.dart';
import 'package:food_mali/Pages/food_page.dart';
import 'package:food_mali/components/My_current_location.dart';
import 'package:food_mali/components/description_box.dart';
import 'package:food_mali/components/my_drawer.dart';
import 'package:food_mali/components/my_food_tile.dart';
import 'package:food_mali/components/my_sliver_app.dart';
import 'package:food_mali/components/my_tab_bar.dart';
import 'package:food_mali/model/food.dart';
import 'package:food_mali/model/restaurants.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
// tab controller
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: FoodCategory.values.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // sort out and return a list of food items that belong to a specific category
  List<Food> _filterMenuByCategory(FoodCategory category, List<Food> fullMenu){
    return fullMenu.where((food)=>food.category == category).toList();

  }

  // return list of food in given category
  List<Widget> getFoodInThisCategoy(List<Food> fullMenu){
    return FoodCategory.values.map((category){
      // get category menu
      List<Food> categoryMenu = _filterMenuByCategory(category, fullMenu);
      return ListView.builder(
          itemCount: categoryMenu.length,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            // get indivual food
            final food = categoryMenu[index];
            // return food tile Ui
            return FoodTile(
                onTap: ()=> Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context)=> FoodPage(food: food))),
                food: food);
          });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  MySliverApp(
                     child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Divider(
                          indent: 25,
                          endIndent: 25,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        // my current location
                         MyCurrentLocation(),
                        // description box
                        MyDescriptionBox(),
                      ],
                    ),
                    title: MyTabBar(tabController: _tabController))
              ],
          body: Consumer<Restaurants>(builder: (context, restaurant , child) =>
              TabBarView(
                  controller: _tabController,
                  children:getFoodInThisCategoy(restaurant.menu)
              ))
    ));
  }
}
