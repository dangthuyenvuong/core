import 'dart:io';

import 'package:core/core.dart';
import 'package:core/models/auth/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// class LoginResponse {
//   final UserModel user;
//   final TokenModel token;
//   LoginResponse({required this.user, required this.token});
// }

class AuthService {
  static bool get isLoggedIn => StorageService.get('userId') != null;

  static Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);
        return await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (e) {
      print("Lỗi đăng nhập Facebook: $e");
    }
    return null;
  }

  static Future<dynamic?> signInWithGoogle() async {
    final user = await GoogleService.signInWithGoogle();
    if (user != null) {
      final idToken = await user.getIdToken();
      final response = await Http.post(
        '/gym_social/auth/login-with-google',
        body: {'id_token': idToken},
      );
      return response['data'];
     
    }
    return null;
  }

  static Future<void> signOut() async {
    // await GoogleSignIn().signOut();
    // await _auth.signOut();
  }

  static Future<dynamic?> signInWithApple() async {
    final user = await GoogleService.signInWithApple();
    if (user != null) {
      final idToken = await user.getIdToken();
      final response = await Http.post(
        '/auth/v1/login-with-google',
        body: {'id_token': idToken},
      );
      return response['data'];
    }
    return null;
  }
}

bool isSimulator() {
  return !Platform.isAndroid &&
      !Platform.isWindows &&
      !Platform.isLinux &&
      !Platform.isMacOS;
}
