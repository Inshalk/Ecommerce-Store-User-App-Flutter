import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store/controllers/product_controller.dart';
import 'package:mac_store/controllers/subcategory_controller.dart';
import 'package:mac_store/models/category.dart';
import 'package:mac_store/models/product.dart';
import 'package:mac_store/models/subcategory.dart';
import 'package:mac_store/views/screens/detail/screens/subcategory_product_screen.dart';
import 'package:mac_store/views/screens/detail/screens/widgets/inner_banner_widget.dart';
import 'package:mac_store/views/screens/detail/screens/widgets/inner_header_widget.dart';
import 'package:mac_store/views/screens/detail/screens/widgets/subcategory_tile_widget.dart';
import 'package:mac_store/views/screens/nav_screens/widget/product_item_widget.dart';
import 'package:mac_store/views/screens/nav_screens/widget/reusable_text_widget.dart';

class InnerCategoryContentWidget extends StatefulWidget {
  final Category category;
  const InnerCategoryContentWidget({super.key, required this.category});

  @override
  State<InnerCategoryContentWidget> createState() =>
      _InnerCategoryContentWidgetState();
}

class _InnerCategoryContentWidgetState
    extends State<InnerCategoryContentWidget> {
  late Future<List<SubCategory>> _subcategories;
  late Future<List<Product>> futureProducts;
  final SubCategoryController _subCategoryController = SubCategoryController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subcategories = _subCategoryController
        .getSubCategoriesByCategoryName(widget.category.name);
    futureProducts =
        ProductController().loadProductByCategory(widget.category.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 20),
          child: InnerHeaderWidget()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InnerBannerWidget(image: widget.category.banner),
            Center(
              child: Text('Shop by Category',
                  style: GoogleFonts.quicksand(
                    fontSize: 19,
                    letterSpacing: 1.7,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            FutureBuilder(
                future: _subcategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          'Error while loading categories: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No categories Found'),
                    );
                  } else {
                    final subcategories = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: List.generate(
                            (subcategories.length / 7).ceil(), (setIndex) {
                          //For each row calculate the starting and ending indices
                          final start = setIndex * 7;
                          final end = (setIndex + 1) * 7;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              //Create a Row of subcategory tie
                              children: subcategories
                                  .sublist(
                                      start,
                                      end > subcategories.length
                                          ? subcategories.length
                                          : end)
                                  .map((subcategory) => GestureDetector(
                                    onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context){
                                          return SubcategoryProductScreen(subCategory: subcategory);
                                        }));
                                      },
                                    child: SubcategoryTileWidget(
                                        image: subcategory.image,
                                        title: subcategory.subCategoryName),
                                  ))
                                  .toList(),
                            ),
                          );
                        }),
                      ),
                    );
                  }
                }),
            const ReusableTextWidget(
                title: 'Popular products', subTitle: 'view all'),
            FutureBuilder(
                future: futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          'Error while retriving products by category: ${snapshot.error}'),
                    );
                  } else if (snapshot.data!.isEmpty || !(snapshot.hasData)) {
                    return const Center(
                      child: Text('No products available in this category'),
                    );
                  } else {
                    final products = snapshot.data;
                    return SizedBox(
                      height: 250,
                      child: ListView.builder(
                          itemCount: products!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductItemWidget(
                              product: product,
                            );
                          }),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
