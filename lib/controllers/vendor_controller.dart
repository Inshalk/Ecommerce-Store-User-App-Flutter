import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:mac_store/global_variable.dart';
import 'package:mac_store/models/vendor_model.dart';

class VendorController {


  //Fetch Banners
  Future<List<Vendor>> loadVendors() async {
    try {
      //Send an http requiest to fetch banners
      http.Response response = await http.get(Uri.parse("$uri/api/vendors"),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8'
          });
      print(response.body);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Vendor> vendors =
            data.map((vendor) => Vendor.fromJson(vendor)).toList();
        return vendors;
      }else if(response.statusCode==404){
        return [];
      }  
      else {
        //throw an exception if the server throeing error code
        throw Exception('Failed to Load vendors');
      }
    } catch (e) {
      throw Exception('Error Loading vendors $e');
    }
  }
}
