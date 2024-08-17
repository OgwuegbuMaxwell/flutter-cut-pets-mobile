import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [UserProvider] is a class that manages the user's state throughout the app.
/// It uses Flutter's [ChangeNotifier] to notify listeners about changes in the user state,
/// such as when the user logs in, logs out, or when the app loads the user's data from storage.
class UserProvider with ChangeNotifier {
  // Private variables to store user-related data
  String? _accessToken;   // Stores the user's access token
  String? _tokenType;     // Stores the type of token (e.g., "bearer")
  int? _userId;           // Stores the user's ID
  String? _username;      // Stores the user's username

  // Public getters to access user data
  String? get accessToken => _accessToken;
  String? get tokenType => _tokenType;
  int? get userId => _userId;
  String? get username => _username;

  // Boolean getter to check if the user is logged in
  // Returns true if the user is logged in (i.e., the accessToken is not null)
  bool get isLoggedIn => _accessToken != null;

  /// [loadUserData] loads the user data (accessToken, tokenType, userId, username) from 
  /// [SharedPreferences], a persistent storage solution in Flutter.
  /// This method is usually called when the app starts to check if a user
  /// is already logged in.
  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');  // Retrieve the access token
    _tokenType = prefs.getString('token_type');      // Retrieve the token type
    _userId = prefs.getInt('user_id');               // Retrieve the user ID
    _username = prefs.getString('username');         // Retrieve the username


    // Print the loaded data to confirm it's being loaded correctly
    // print("Token.....: $_accessToken");
    // print("User ID....: $_userId");
    // print("Username....: $_username");

    // Notify listeners (e.g., UI components) about the change in user state
    notifyListeners();
  }



  


  /// [saveUserData] stores the user data (accessToken, tokenType, userId, username) in 
  /// [SharedPreferences] to persist the user's session across app launches.
  /// This method is typically called after a successful login.
  Future<void> saveUserData(String accessToken, String tokenType, int userId, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Save the access token, token type, user ID, and username to SharedPreferences
    await prefs.setString('access_token', accessToken);
    await prefs.setString('token_type', tokenType);
    await prefs.setInt('user_id', userId);
    await prefs.setString('username', username);
    
    // Update the provider's state variables
    _accessToken = accessToken;
    _tokenType = tokenType;
    _userId = userId;
    _username = username;
    
    // Notify listeners about the change in user state
    notifyListeners();
  }

  /// [logout] clears the user data from [SharedPreferences] and resets the 
  /// provider's state, effectively logging the user out.
  /// This method is typically called when the user chooses to log out.
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Clear all user-related data from SharedPreferences
    await prefs.clear();
    
    // Reset the provider's state variables
    _accessToken = null;
    _tokenType = null;
    _userId = null;
    _username = null;
    
    // Notify listeners about the change in user state (i.e., the user has logged out)
    notifyListeners();
  }
}


