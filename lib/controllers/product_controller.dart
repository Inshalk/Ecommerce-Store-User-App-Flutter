import 'dart:convert';

import 'package:mac_store/global_variable.dart';
import 'package:mac_store/models/product.dart';
import 'package:http/http.dart' as http;

class ProductController {
  Future<List<Product>> loadPopularProducts() async {
    try {
      http.Response response = await http.get(
          Uri.parse('$uri/api/popular-products'),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8'
          });

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

        final List<Product> products = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return products;
      } else {
        throw Exception('Failed to load Popular-products ');
      }
    } catch (e) {
      throw Exception('Failed to load Popular-products: $e ');
    }
  }

  //Load products by category
  Future<List<Product>> loadProductByCategory(String category) async {
    try {
      http.Response response = await http.get(
          Uri.parse('$uri/api/products-by-category/$category'),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8'
          });
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

        final List<Product> products = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load Popular-products ');
      }
    } catch (e) {
      throw Exception('Failed to load Popular-products: $e ');
    }
  }

  // Show related products by subcategory
  Future<List<Product>> loadRelatedProductBySubcategory(
      String productId) async {
    try {
      http.Response response = await http.get(
          Uri.parse('$uri/api/related-products-by-subcategories/$productId'),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8'
          });
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

        final List<Product> relatedProducts = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return relatedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load Related-products ');
      }
    } catch (e) {
      throw Exception('Failed to load Related-products: $e ');
    }
  }

  // Show highest rated top 10 products
  Future<List<Product>> loadTopRatedProduct() async {
    try {
      http.Response response = await http.get(
          Uri.parse('$uri/api/top-rated-products'),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8'
          });
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

        final List<Product> topRatedProducts = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return topRatedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load top-rated-products ');
      }
    } catch (e) {
      throw Exception('Failed to load top-rated-products: $e ');
    }
  }

  // load products by subcategory
  Future<List<Product>> loadProductsBySubcategory(
      String subCategory) async {
    try {
      http.Response response = await http.get(
          Uri.parse('$uri/api/products-by-subcategory/$subCategory'),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8'
          });
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

        final List<Product> relatedProducts = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return relatedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load subcategory-products ');
      }
    } catch (e) {
      throw Exception('Failed to load subcategory-products: $e ');
    }
  }

  // Method to search products by name or desc
  Future<List<Product>> searchProduct(String query) async {

    try {
      http.Response response = await http.get(
          Uri.parse('$uri/api/search-products?query=$query'),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8'
          });
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

        final List<Product> serachedProducts = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return serachedProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load searched products ');
      }
    } catch (e) {
      throw Exception('Failed to load searched products: $e ');
    }
  }

Future<List<Product>> loadVendorProducts(
      String vendorId) async {
    try {
      http.Response response = await http.get(
          Uri.parse('$uri/api/products/vendor/$vendorId'),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8'
          });
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

        final List<Product> vendorProducts = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return vendorProducts;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load vendor-products ');
      }
    } catch (e) {
      throw Exception('Failed to load vendor-products: $e ');
    }
  }

}
