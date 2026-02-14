import 'package:flutter/material.dart';
import 'package:food_mali/model/food.dart';

class MyTabBar extends StatelessWidget {

  final TabController tabController;
  const  MyTabBar({super.key, required this.tabController});

  List<Tab> _buildCategoryTabs(){
    return FoodCategory.values.map((catgory){
      return Tab(
        text: catgory.toString().split('.').last,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: TabBar(
        controller: tabController,
          tabs:_buildCategoryTabs(),
      )
    );
  }
}
