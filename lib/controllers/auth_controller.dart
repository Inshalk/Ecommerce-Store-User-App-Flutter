import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store/global_variable.dart';
import 'package:mac_store/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:mac_store/provider/delivered_order_count_provider.dart';
import 'package:mac_store/provider/user_provider.dart';
import 'package:mac_store/services/manage_http_response.dart';
import 'package:mac_store/views/screens/authentication_screens/login_screen.dart';
import 'package:mac_store/views/screens/authentication_screens/otp_screen.dart';
import 'package:mac_store/views/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// final providerContainer = ProviderContainer();

class AuthController {
  Future<void> signUpUsers({
    required BuildContext context,
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        fullName: fullName,
        email: email,
        state: '',
        city: '',
        locality: '',
        password: password,
        token: '',
      );
      http.Response response = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user
            .toJson(), //Converts the user object to json body for request body
        headers: <String, String>{
          //Set the header for the request
          'Content-Type':
              'application/json; charset=UTF-8', //specify the context type as json
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OtpScreen(email: email)),
          );
          showSnackBar(context, "Account created successfully");
        },
      );
    } catch (e) {
      print('Signup error: $e');
    }
  }

  //Sign-in User function

  Future<void> signInUsers({
    required BuildContext context,
    required String email,
    required String password,
    required WidgetRef ref,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/signin"),
        body: jsonEncode({
          'email': email, //Include the email in the request body
          'password': password, //Include the password in the request body
        }),
        headers: <String, String>{
          //This will set the headers
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      //handle the response using httpResponse
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          //Access the shared prefrence for token and user data storage
          SharedPreferences preferences = await SharedPreferences.getInstance();
          //Extract the authToken from the response body
          String token = jsonDecode(response.body)['token'];

          //Store the Authentication token securely in shared preffrence
          await preferences.setString('auth_token', token);

          //Encode the user data recive from the backend as json
          final userJson = jsonEncode(jsonDecode(response.body));

          //Update the application state with the user data with riverpod
          ref.read(userProvider.notifier).setUser(response.body);

          //Store the data in sharedPrefference for future use
          await preferences.setString('user', userJson);
          
          if(ref.read(userProvider)!.token.isNotEmpty){
             Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (route) => false,
          );
          showSnackBar(context, "Account Login successfully");
          }

         
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }


  getUserData(context,WidgetRef ref) async{
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token=preferences.getString('auth_token');

      if(token==null){
        preferences.setString('auth_token', '');
      }

     var tokenResponse= await http.post(Uri.parse('$uri/tokenIsValid'),
       headers: <String, String>{
        "Content-Type": 'application/json; charset=UTF-8',
        "x-auth-token":token!,
      },
      );
    var response =jsonDecode(tokenResponse.body);

    if(response==true){
    http.Response userResponse= await http.get(Uri.parse('$uri/'),
       headers: <String, String>{
        "Content-Type": 'application/json; charset=UTF-8',
        "x-auth-token":token,
      },
      );
    ref.read(userProvider.notifier).setUser(userResponse.body);
    }


    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //SignOut
  Future<void> signOutUser({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      //Clear the token and user from the shredprefference
      await preferences.remove('auth_token');
      await preferences.remove('user');

      //clear the user state
      ref.read(userProvider.notifier).signOut();

      ref.read(deliveredOrderCountProvider.notifier).resetCount();

      //Navigate the user back to the loginScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ),
        (route) => false,
      );

      showSnackBar(context, 'Sign out successfully');
    } catch (e) {
      showSnackBar(context, 'Error While Sign out: ${e} ');
    }
  }

  //Update user's state , city and locality
  Future<void> updateUserLocation({
    required BuildContext context,
    required String id,
    required String state,
    required String city,
    required String locality,
    required WidgetRef ref,
  }) async {
    try {
      final http.Response response = await http.put(
        Uri.parse("$uri/api/users/$id"),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
        //Encode and update the data {state,city,locality} As json object
        body: jsonEncode({'state': state, 'city': city, 'locality': locality}),
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          //Decode the updated user data from the response body
          //this converts the json String response into Dart Map
          final updatedUser = jsonDecode(response.body);
          //Access Shared preference for local data storage
          //shared preferences allow us to store data persisitently on the the device
          SharedPreferences preferences = await SharedPreferences.getInstance();
          //Encode the update user data as json String
          //this prepares the data for storage in shared preference
          final userJson = jsonEncode(updatedUser);
          //Update the application state with the updeted user data using riverpod
          ref.read(userProvider.notifier).setUser(userJson);

          //store the updated user data in shared prefference
          await preferences.setString('user', userJson);
        },
      );
    } catch (e) {
      showSnackBar(context, 'Error updating location');
    }
  }

  //Verify Otp
  Future<void> verifyOtp({
    required BuildContext context,
    required String email,
    required String otp,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/verify-otp'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"email": email, "otp": otp}),
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
          );
          showSnackBar(context, 'Account verified please log-in to continue ');
        },
      );
    } catch (e) {
      showSnackBar(context, "error verifing otp: $e");
    }
  }


//Delete api
  Future<void> deleteAccount({
    required BuildContext context,
    required String id,
    required WidgetRef ref //access to the riverpod provier
  })async{
    try {
      //get authnc token with shared preference
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String ? token = preferences.getString('auth_token');
      
      if(token==null){
        showSnackBar(context, 'You need to log in to perform this action');
        return;
      }

      //Send delete req to backend api
      http.Response response= await http.delete(Uri.parse('$uri/api/user/delete-account/$id'),
       headers: <String, String>{
        "Content-Type": 'application/json; charset=UTF-8',
        "x-auth-token":token,
      }
      );

      manageHttpResponse(response: response, context: context, onSuccess: ()async{
        //handle deletion of the user navigate the user back to login screen
        
        //Clear data from sharedpreference

        await preferences.remove('auth_token');
        await preferences.remove('user');

        ref.read(userProvider.notifier).signOut();
        showSnackBar(context, 'Account deleted successfully');

        Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
              return LoginScreen();
            }), (route) => false);

      });

    } catch (e) {
      showSnackBar(context, 'error deleting accound:$e');
    }
  }
}
