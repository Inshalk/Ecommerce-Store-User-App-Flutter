import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store/models/product.dart';

class ProductProvider extends StateNotifier<List<Product>>{
  ProductProvider():super([]);


  //Set the List of products
  void setProducts(List<Product> products){
    state=products;
  }

}

final productProvider=StateNotifierProvider<ProductProvider,List<Product>>((ref){
  return ProductProvider();
} );