import 'package:flutter/material.dart';

import 'package:mac_store/views/screens/nav_screens/widget/popular_product_widget.dart';
import 'package:mac_store/views/screens/nav_screens/widget/reusable_text_widget.dart';
import 'package:mac_store/views/screens/nav_screens/widget/top_rated_product_widget.dart';


class ProductsHomeWidget extends StatelessWidget {
  const ProductsHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        ReusableTextWidget(title: 'Popular products', subTitle: 'View all'),
                  PopularProductWidget(),          
        
        SizedBox(height: 20),         
        ReusableTextWidget(title: 'Top Rated Products', subTitle: ''),
        TopRatedProductWidget(),
      ],
    );
  }
}