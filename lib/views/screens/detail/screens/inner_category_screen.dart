import 'package:flutter/material.dart';
import 'package:mac_store/models/category.dart';
import 'package:mac_store/views/screens/detail/screens/widgets/inner_category_content_widget.dart';
import 'package:mac_store/views/screens/nav_screens/account_screen.dart';
import 'package:mac_store/views/screens/nav_screens/cart_screen.dart';
import 'package:mac_store/views/screens/nav_screens/category_screen.dart';
import 'package:mac_store/views/screens/nav_screens/favorite_screen.dart';
import 'package:mac_store/views/screens/nav_screens/store_screen.dart';

class InnerCategoryScreen extends StatefulWidget {
  final Category category;
  const InnerCategoryScreen({super.key, required this.category});

  @override
  State<InnerCategoryScreen> createState() => _InnerCategoryScreenState();
}

class _InnerCategoryScreenState extends State<InnerCategoryScreen> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // List of pages available within this screen
    final List<Widget> _pages = [
      InnerCategoryContentWidget(category: widget.category),
      const FavoriteScreen(),
      const CategoryScreen(),
      const StoreScreen(),
      const CartScreen(),
      AccountScreen()
    ];

    return Scaffold(
      body: _pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: _pageIndex,
        onTap: (value) {
          if (value == 0) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _pageIndex = value;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/home.png',
              width: 25,
              color: _pageIndex == 0 ? Colors.purple : Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/love.png',
              width: 25,
              color: _pageIndex == 1 ? Colors.purple : Colors.grey,
            ),
            label: 'Favorite',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.category), 
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/mart.png',
              width: 25,
              color: _pageIndex == 3 ? Colors.purple : Colors.grey,
            ),
            label: 'Stores',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/cart.png',
              width: 25,
              color: _pageIndex == 4 ? Colors.purple : Colors.grey,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/user.png',
              width: 25,
              color: _pageIndex == 5 ? Colors.purple : Colors.grey,
            ),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}