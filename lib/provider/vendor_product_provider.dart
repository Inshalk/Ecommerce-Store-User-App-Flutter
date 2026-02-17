import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store/models/product.dart';

class VendorProductProvider extends StateNotifier<List<Product>>{
  VendorProductProvider():super([]);


  //Set the List of products
  void setProducts(List<Product> products){
    state=products;
  }

}

final vendorProductProvider=StateNotifierProvider<VendorProductProvider,List<Product>>((ref){
  return VendorProductProvider();
} );