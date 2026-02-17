import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store/models/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Define a StateNotifierProvider to expose an instance of the CartNofier and item accessible to our app
final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, Cart>>((ref) {
  return CartNotifier();
});

//managing cart state
class CartNotifier extends StateNotifier<Map<String, Cart>> {
  CartNotifier() : super({}){
    _loadCartItems();
  }


  //A private method that loads items from sharedprefference
  Future<void> _loadCartItems() async{
    //Retrive the sharedprefference intance to store data
    final prefs=await SharedPreferences.getInstance();
    //Fetch the json String of favorite items with key
    final cartString= prefs.getString('cart_items');
    //check if null
    if(cartString!=null){
      //decode the json string into the map of dynamic data
     final Map<String,dynamic> cartMap =jsonDecode(cartString); 

     //Convert the dynamic map into a map of favorite object using the fromjson factory method
     final cartItems= cartMap.map((key, value) => MapEntry(key, Cart.fromJson(value)));

     //Updating the state with the loaded favorites
     state=cartItems;

    }

  }

  //A private method that saves the current list of favorite items to sharedprefference
  Future<void> _saveCartItems() async{
    //Retrive the sharedprefference intance to store data
    final prefs=await SharedPreferences.getInstance();
    //Encode the current state (Map of favorite object) to json string
    final cartString= jsonEncode(state);
    //Saving the json string to sharedpreference with key 'favorites'
    await prefs.setString('cart_items', cartString);
  }



  void addProductToCart({
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
  }) {
    if (state.containsKey(productId)) {
      state = {
        ...state,
        productId: Cart(
            productName: state[productId]!.productName,
            productPrice: state[productId]!.productPrice,
            category: state[productId]!.category,
            image: state[productId]!.image,
            vendorId: state[productId]!.vendorId,
            productQuantity: state[productId]!.productQuantity,
            quantity: state[productId]!.quantity + 1,
            productId: state[productId]!.productId,
            description: state[productId]!.description,
            fullName: state[productId]!.fullName)
      };
      _saveCartItems();
    } else {
      state = {
        ...state,
        productId: Cart(
            productName: productName,
            productPrice: productPrice,
            category: category,
            image: image,
            vendorId: vendorId,
            productQuantity: productQuantity,
            quantity: quantity,
            productId: productId,
            description: description,
            fullName: fullName)
      };
      _saveCartItems();
    }
  }

  void incrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity++;

      //Notify listner that state has changed
      state = {...state};
      _saveCartItems();
    }
  }

  void decrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity--;

      //Notify listner that state has changed
      state = {...state};
      _saveCartItems();
    }
  }

  void removeCartItem(String productId) {
    state.remove(productId);
    // Notify listner that state has changed
    state = {...state};
    _saveCartItems();
  }

  double calculateTotalAmount() {
    double totalAmount = 0.0;

    state.forEach((productId, cartItem) {
      totalAmount += cartItem.quantity * cartItem.productPrice;
    });
    return totalAmount;
  }
  
  //Method to clear cart items
  void clearCart(){
    state={};

    //Notify listeners that state has changed
    state={...state};
    _saveCartItems();
  }

  Map<String, Cart> get getCartItems => state;
}
