import 'dart:io';

import 'package:core/http.dart';
import 'package:core/models/auth.model.dart';
import 'package:core/models/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// class LoginResponse {
//   final UserModel user;
//   final TokenModel token;
//   LoginResponse({required this.user, required this.token});
// }

class AuthService {
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);
      return userCredential;
    } catch (e) {
      print("Lỗi đăng nhập Google: $e");
    }
    return null;
  }

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

  static Future<AuthorizationCredentialAppleID> signInWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    return credential;
  }

  // static Future<LoginResponse> fakeLogin(String url) async {
  //   final response = await Http.post(
  //     url,
  //   );

  //   return LoginResponse(
  //     user: UserModel.fromJson(response['data']['user']),
  //     token: TokenModel.fromJson(response['data']['token']),
  //   );
  // }
}

bool isSimulator() {
  return !Platform.isAndroid &&
      !Platform.isWindows &&
      !Platform.isLinux &&
      !Platform.isMacOS;
}
