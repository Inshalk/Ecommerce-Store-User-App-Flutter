import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store/controllers/product_controller.dart';
import 'package:mac_store/models/product.dart';
import 'package:mac_store/provider/product_provider.dart';
import 'package:mac_store/provider/top_rated_product_provider.dart';
import 'package:mac_store/views/screens/nav_screens/widget/product_item_widget.dart';

class TopRatedProductWidget extends ConsumerStatefulWidget {
  const TopRatedProductWidget({super.key});

  @override
  ConsumerState<TopRatedProductWidget> createState() => _PopularProductWidgetState();
}

class _PopularProductWidgetState extends ConsumerState<TopRatedProductWidget> {
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
        final products=await productController.loadTopRatedProduct();
        ref.read(topRatedProductProvider.notifier).setProducts(products);
      } catch (e) {
        print('$e');
      } finally{
        setState(() {
          isLoading=false;
        });
      }
    }
  

  @override
  Widget build(BuildContext context) {
    final products=ref.watch(topRatedProductProvider);
    return isLoading?const Center(child: CircularProgressIndicator(color: Colors.blue,),) :GridView.builder(
        shrinkWrap: true, 
        physics: const NeverScrollableScrollPhysics(), 
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          mainAxisSpacing: 10, 
          crossAxisSpacing: 10, 
          childAspectRatio: 0.75,  
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductItemWidget(product: product);
        },
      );
  }
}
