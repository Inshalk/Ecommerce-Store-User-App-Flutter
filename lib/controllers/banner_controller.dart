import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:mac_store/global_variable.dart';
import 'package:mac_store/models/banner_model.dart';

class BannerController {


  //Fetch Banners
  Future<List<BannerModel>> loadBanners() async {
    try {
      //Send an http requiest to fetch banners
      http.Response response = await http.get(Uri.parse("$uri/api/banner"),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8'
          });
      

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<BannerModel> banners =
            data.map((banner) => BannerModel.fromJson(banner)).toList();
        return banners;
      }else if(response.statusCode==404){
        return [];
      }  
      else {
        //throw an exception if the server throeing error code
        throw Exception('Failed to Load Banners');
      }
    } catch (e) {
      throw Exception('Error Loading Banners $e');
    }
  }
}
