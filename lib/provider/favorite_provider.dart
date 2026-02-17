import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store/models/favorite.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Define a StateNotifierProvider to expose an instance of the fav Notifier and item accessible to our app
final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, Map<String, Favorite>>((ref) {
  return FavoriteNotifier();
});

class FavoriteNotifier extends StateNotifier<Map<String,Favorite>>{
  FavoriteNotifier():super({}){
    _loadFavorites();
  }
  
  //A private method that loads items from sharedprefference
  Future<void> _loadFavorites() async{
    //Retrive the sharedprefference intance to store data
    final prefs=await SharedPreferences.getInstance();
    //Fetch the json String of favorite items with key
    final favoriteString= prefs.getString('favorites');
    //check if null
    if(favoriteString!=null){
      //decode the json string into the map of dynamic data
     final Map<String,dynamic> favoriteMap =jsonDecode(favoriteString); 

     //Convert the dynamic map into a map of favorite object using the fromjson factory method
     final favorites= favoriteMap.map((key, value) => MapEntry(key, Favorite.fromJson(value)));

     //Updating the state with the loaded favorites
     state=favorites;

    }

  }



  //A private method that saves the current list of favorite items to sharedprefference
  Future<void> _saveFavorites() async{
    //Retrive the sharedprefference intance to store data
    final prefs=await SharedPreferences.getInstance();
    //Encode the current state (Map of favorite object) to json string
    final favoriteString= jsonEncode(state);
    //Saving the json string to sharedpreference with key 'favorites'
    await prefs.setString('favorites', favoriteString);
  }

  void addProductToFavorite({
     required String productName,
    required int productPrice,
    required String category,
    required List<String> image,
    required String vendorId,
    required int productQuantity,
    required int quantity,
    required String productId,
    required String description,
    required String fullName,
  }){
    
    state[productId]=Favorite(productName: productName, productPrice: productPrice, category: category, image: image, vendorId: vendorId, productQuantity: productQuantity, quantity: quantity, productId: productId, description: description, fullName: fullName);

    //Notify the listener that the state has changed
    state= {...state};
    _saveFavorites();

  }

   void removeFavoriteItem(String productId) {
    state.remove(productId);
    // Notify listner that state has changed
    state = {...state};
    _saveFavorites();
  }

  Map<String, Favorite> get getFavoriteItems => state;
}