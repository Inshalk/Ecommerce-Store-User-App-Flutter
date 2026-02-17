import 'package:flutter/material.dart';
import 'package:mac_store/views/screens/nav_screens/widget/banner_widget.dart';
import 'package:mac_store/views/screens/nav_screens/widget/category_item_widget.dart';
import 'package:mac_store/views/screens/nav_screens/widget/header_widget.dart';
import 'package:mac_store/views/screens/nav_screens/widget/products_home_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.20), child: const HeaderWidget()),
        body:const SingleChildScrollView(
      child: Column(
        children: [          
          BannerWidget(),
          CategoryItemWidget(),
          
          ProductsHomeWidget()
        ],
      ),
    ));
  }
}
