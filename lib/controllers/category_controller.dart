import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mac_store/global_variable.dart';
import 'package:mac_store/models/category.dart';

class CategoryController {
 

  //Load the uploaded categories
  Future<List<Category>> loadCategories() async {
    try {
      //Send an http get request to load categories
      http.Response response = await http.get(Uri.parse("$uri/api/categories"),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8'
          });
      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Category> categories =
            data.map((category) => Category.fromJson(category)).toList();
        return categories;
      }else if(response.statusCode==404){
        return [];
      } 
      
       else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error loading categories:$e');
    }
  }
}
