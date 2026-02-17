import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store/models/subcategory.dart';

class SubcategoryProvider extends StateNotifier<List<SubCategory>>{
  SubcategoryProvider():super([]);

  //Set the list of subcategory
  void setSubcategories(List<SubCategory> subcategories){
    state=subcategories;

  }
}
final subcategoryProvider =StateNotifierProvider<SubcategoryProvider,List<SubCategory>>((ref) {
  return SubcategoryProvider();
});