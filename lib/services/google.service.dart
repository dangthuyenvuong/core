import 'dart:convert';
import 'dart:math';
import 'package:core/core.dart';
import 'package:crypto/crypto.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final _auth = FirebaseAuth.instance;

class GoogleService {
  static Stream<User?> get userStream => _auth.authStateChanges();

  static Future<User?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  static Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  /// Tạo nonce ngẫu nhiên
  static String generateNonce([int length = 32]) {
    final random = Random.secure();
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';

    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// SHA256 hash cho nonce
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<User?> signInWithApple() async {
    try {
      // 1. Lấy credential từ Apple
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // 2. Convert sang credential của Firebase
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // 3. Đăng nhập Firebase
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      // 4. Lấy Firebase ID Token
      final firebaseToken = await userCredential.user!.getIdToken();

      return userCredential.user;
    } catch (e) {
      print("ERROR: $e");
    }

    // final rawNonce = generateNonce();
    // final nonce = sha256ofString(rawNonce);
    // try {
    //   final credential = await SignInWithApple.getAppleIDCredential(scopes: [
    //     AppleIDAuthorizationScopes.email,
    //     AppleIDAuthorizationScopes.fullName,
    //   ], nonce: nonce);
    //   return credential;
    // } catch (e) {
    //   print("Lỗi đăng nhập Apple: $e");
    //   throw Exception(e);
    // }
  }
}
