import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store/controllers/product_controller.dart';
import 'package:mac_store/models/product.dart';
import 'package:mac_store/provider/product_provider.dart';
import 'package:mac_store/views/screens/nav_screens/widget/product_item_widget.dart';

class PopularProductWidget extends ConsumerStatefulWidget {
  const PopularProductWidget({super.key});

  @override
  ConsumerState<PopularProductWidget> createState() => _PopularProductWidgetState();
}

class _PopularProductWidgetState extends ConsumerState<PopularProductWidget> {
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
    return SizedBox(
              height: 250,
              child:isLoading? const Center(child: CircularProgressIndicator(color: Colors.blue,)):ListView.builder(
                  itemCount: products.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductItemWidget(product: product,);
                  }),
            );
  }
}
