import 'package:core/controllers/user.controller.dart';
import 'package:core/core.dart';
import 'package:core/models/auth.model.dart';
import 'package:core/services/storage.service.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final _token = Rxn<TokenModel>(null);

  set token(TokenModel? value) {
    _token.value = value;
    StorageService.set('token', value);
  }

  bool isLogin() {
    return token != null;
  }

  TokenModel? get token => _token.value;

  void loadToken() {
    final token = StorageService.get('token');
    if (token != null) {
      this.token = TokenModel.fromJson(token);
    }
  }

  // Future<void> setToken(TokenModel token) async {
  //   this.token = token;
  // }

  // Future<LoginResponse> fakeLogin(String url) async {
  //   final userController = Get.find<UserController>();
  //   final response = await AuthService.fakeLogin(url);
  //   token = response.token;
  //   userController.user = response.user;
  //   return response;
  // }

  Future<void> logout() async {
    token = null;
    final userController = Get.find<UserController>();
    userController.user = null;
  }
}
