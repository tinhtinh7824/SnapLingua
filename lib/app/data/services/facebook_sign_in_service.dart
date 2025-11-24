import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookSignInService {
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  Future<LoginResult> signIn() {
    return _facebookAuth.login(
      permissions: const ['email', 'public_profile'],
    );
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      return await _facebookAuth.getUserData(
        fields: 'id,name,email,picture.width(400)',
      );
    } catch (e) {
      print('Facebook getUserData error: $e');
      return null;
    }
  }

  Future<void> signOut() => _facebookAuth.logOut();
}
