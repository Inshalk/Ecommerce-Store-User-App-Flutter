import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store/controllers/product_controller.dart';
import 'package:mac_store/models/product.dart';
import 'package:mac_store/provider/product_provider.dart';
import 'package:mac_store/views/screens/detail/screens/widgets/inner_header_widget.dart';
import 'package:mac_store/views/screens/nav_screens/widget/product_item_widget.dart';

class PopularProductWidgetVertical extends ConsumerStatefulWidget {
  const PopularProductWidgetVertical({super.key});

  @override
  ConsumerState<PopularProductWidgetVertical> createState() => _PopularProductWidgetVerticalState();
}

class _PopularProductWidgetVerticalState extends ConsumerState<PopularProductWidgetVertical> {
  late Future<List<Product>> futurePopularProducts;
  bool isLoading=true;
  @override
  void initState() {
    super.initState();
    final product=ref.read(productProvider);
    if(product.isEmpty){
    _fetchProduct();
    }else{
      setState(() {
        isLoading=false;
      });
    }
  }
    Future<void> _fetchProduct()async{
      final ProductController productController=ProductController();
      try {
        final products=await productController.loadPopularProducts();
        ref.read(productProvider.notifier).setProducts(products);
      } catch (e) {
        print('$e');
      }finally{
        setState(() {
          isLoading=false;
        });
      }
    }
  

  @override
  Widget build(BuildContext context) {
    final products=ref.watch(productProvider);
    return Scaffold(
      appBar: PreferredSize(
        // FIXED: height * 20 was way too large. 
        // Use a standard height like 80 or a small percentage of height (e.g., 0.1).
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
        child: const InnerHeaderWidget(),
      ),
      body: isLoading
      ? const Center(child: CircularProgressIndicator(color: Colors.blue))
      : GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,          
            crossAxisSpacing: 10,       
            mainAxisSpacing: 10,        
            childAspectRatio: 0.75,     
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductItemWidget(product: product);
          },
        ),
    );
  }
}
