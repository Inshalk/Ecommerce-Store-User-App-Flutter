import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store/models/product.dart';

class SubcategoryProductProvider extends StateNotifier<List<Product>>{
  SubcategoryProductProvider():super([]);


  //Set the List of products
  void setProducts(List<Product> products){
    state=products;
  }

}

final subcategoryProductProvider=StateNotifierProvider.autoDispose<SubcategoryProductProvider,List<Product>>((ref){
  return SubcategoryProductProvider();
} );