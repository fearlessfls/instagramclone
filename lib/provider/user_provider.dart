import 'package:flutter/foundation.dart';
import 'package:instergram_flutter/models/user.dart';
import 'package:instergram_flutter/resources/auth_method.dart';

class UserProvider with ChangeNotifier {
  User? _user = User(
      email: "",
      uid: "",
      photoURL: "",
      username: "",
      bio: "",
      followers: [],
      following: []);
  final AuthMethod _authMethod = AuthMethod();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethod.getUserDetails();
    _user = user;
    if (kDebugMode) {
      print("This Get Called");
    }
    notifyListeners();
  }
}
