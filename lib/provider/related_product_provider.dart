import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store/models/product.dart';

class RelatedProductProvider extends StateNotifier<List<Product>>{
  RelatedProductProvider():super([]);


  //Set the List of products
  void setProducts(List<Product> products){
    state=products;
  }

}

final relatedProductProvider=StateNotifierProvider<RelatedProductProvider,List<Product>>((ref){
  return RelatedProductProvider();
} );