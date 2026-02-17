
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store/models/user.dart';

class UserProvider extends StateNotifier<User?> {
  //constructor initializing with default User object

  UserProvider()
      : super(User(
            id: '',
            fullName: '',
            email: '',
            state: '',
            city: '',
            locality: '',
            password: '',
            token: ''));
  //Getter methods to Extract user values
  User? get user => state;

  //Method to set user state from json it updates the user state based on json

  void setUser(String userJson) {
    state = User.fromJson(userJson);
  }

  //Method to clear user state
  void signOut() {
    state = null;
  }

  void recreateUserState({
    required String state,
    required String city,
    required String locality,
  }) {
    if (this.state != null) {
      this.state = User(
          id: this.state!.id,//Preserve the id
          fullName: this.state!.fullName,//Preserve the fullname
          email: this.state!.email,//Preserve the email
          state: state,
          city: city,
          locality: locality,
          password: this.state!.password,//Preserve the pass
          token: this.state!.token,//Preserve the token
          );
    }
  }
}

//make the data accessible within the application
final userProvider =
    StateNotifierProvider<UserProvider, User?>((ref) => UserProvider());
