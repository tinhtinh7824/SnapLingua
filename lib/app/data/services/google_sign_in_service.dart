import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
    // Client ID từ Google Cloud Console (Web Client ID để lấy idToken)
    serverClientId: '814540077533-nmn2gp2tlm7olr7ke013josvm5e2hdn9.apps.googleusercontent.com',
  );

  /// Đăng nhập bằng Google
  Future<GoogleSignInAccount?> signIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      return account;
    } catch (error) {
      print('Google Sign-In Error: $error');
      return null;
    }
  }

  /// Đăng xuất Google
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  /// Kiểm tra trạng thái đăng nhập
  Future<GoogleSignInAccount?> get currentUser async {
    return await _googleSignIn.signInSilently();
  }

  /// Lấy ID token để gửi lên server
  Future<String?> getIdToken(GoogleSignInAccount account) async {
    try {
      final GoogleSignInAuthentication auth = await account.authentication;
      print('Google Auth - ID Token: ${auth.idToken != null ? "OK" : "NULL"}');
      print('Google Auth - Access Token: ${auth.accessToken != null ? "OK" : "NULL"}');
      return auth.idToken;
    } catch (e) {
      print('Error getting idToken: $e');
      return null;
    }
  }

  /// Lấy thông tin authentication đầy đủ
  Future<GoogleSignInAuthentication?> getAuthentication(GoogleSignInAccount account) async {
    return await account.authentication;
  }
}
