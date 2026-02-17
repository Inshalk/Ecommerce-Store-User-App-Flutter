import 'dart:convert';

import 'package:mac_store/global_variable.dart';
import 'package:mac_store/models/subcategory.dart';
import 'package:http/http.dart' as http;

class SubCategoryController {
  Future<List<SubCategory>> getSubCategoriesByCategoryName(
      String categoryName) async {
    try {
      http.Response response = await http.get(
          Uri.parse("$uri/api/category/$categoryName/subcategories"),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8'
          });
          if(response.statusCode==200){
            final List<dynamic> data=jsonDecode(response.body);
            if(data.isNotEmpty){
              return data.map((subcategory)=>SubCategory.fromJson(subcategory)).toList();
            }else{
              print("Subcategories not found");
              return [];
            }

          }else if(response.statusCode==404){
            print("Subcategories not found");
            return [];

          }
          else{
            print("failed to fetch Subcategories ");
            return [];
          }
    } catch (e) {
      print("Error fetching Subcategories $e");
      return [];
    }
  }
}
