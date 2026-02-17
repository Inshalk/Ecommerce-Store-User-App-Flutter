import 'package:flutter/material.dart';
import 'package:mac_store/views/screens/main_screen.dart';
import 'package:mac_store/views/screens/nav_screens/account_screen.dart';
import 'package:mac_store/views/screens/nav_screens/cart_screen.dart';
import 'package:mac_store/views/screens/nav_screens/category_screen.dart';
import 'package:mac_store/views/screens/nav_screens/favorite_screen.dart';
import 'package:mac_store/views/screens/nav_screens/store_screen.dart';
import 'package:mac_store/views/screens/nav_screens/widget/popular_product_widget_vertical.dart';

class ViewPopularScreen extends StatefulWidget {
  const ViewPopularScreen({super.key});

  @override
  State<ViewPopularScreen> createState() => _ViewPopularScreenState();
}

class _ViewPopularScreenState extends State<ViewPopularScreen> {
  int _pageIndex = 0;

 
  final List<Widget> _pages = [
    const PopularProductWidgetVertical(), 
    const FavoriteScreen(),
    const CategoryScreen(),
    const StoreScreen(),
    const CartScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: _pageIndex,
        onTap: (value) {
          // If user clicks Home (index 0) and they are NOT already on the popular grid,
          // go back to MainScreen. Otherwise, just update the local state.
          if (value == 0) {
             Navigator.of(context).pushAndRemoveUntil(              
              MaterialPageRoute(builder: (context) => const MainScreen()),
              (route)=>false,
            );
          } else {
            setState(() {
              _pageIndex = value;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('./assets/icons/home.png', width: 25),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('./assets/icons/love.png', width: 25),
            label: 'Favorite',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('./assets/icons/mart.png', width: 25),
            label: 'Stores',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('./assets/icons/cart.png', width: 25),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('./assets/icons/user.png', width: 25),
            label: 'Account',
          ),
        ],
      ),
     
      body: _pages[_pageIndex],
    );
  }
}