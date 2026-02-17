import 'package:flutter/material.dart';
import 'package:mac_store/views/screens/detail/screens/search_product_screen.dart';

class InnerHeaderWidget extends StatelessWidget {
  const InnerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Adjust height to the status bar + content
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/searchBanner.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        children: [
          // Search Field
          Expanded(
            child: SizedBox(
              height: 45,
              child: TextField(
                readOnly: true,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SearchProductScreen();
                  }));
                },
                decoration: InputDecoration(
                  hintText: 'Search Products',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7F7F7F),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset('./assets/icons/searc1.png'),
                  ),
                  fillColor: Colors.white.withOpacity(0.9), 
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Bell Icon
          _buildIconButton('./assets/icons/bell.png', () {}),
          const SizedBox(width: 10),
          // Message Icon
          _buildIconButton('./assets/icons/message.png', () {}),
        ],
      ),
    );
  }

 Widget _buildIconButton(String assetPath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40, 
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2), 
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Image.asset(
            assetPath,
            width: 22,
            height: 22,            
          ),
        ),
      ),
    );
  }
}