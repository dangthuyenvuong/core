import 'package:core/controllers/user.controller.dart';
import 'package:core/core.dart';
import 'package:core/models/auth.model.dart';
import 'package:core/models/auth/model.dart';
import 'package:core/services/auth.service.dart';
import 'package:core/services/storage.service.dart';
import 'package:get/get.dart';
import "package:core/extensions/list.dart";

class _AuthController extends GetxController {
  final _token = Rxn<TokenModel>(null);
  final _userId = Rxn<String>(null);
  final _accessToken = Rxn<String>(null);
  final _refreshToken = Rxn<String>(null);
  final _multipleLogin = RxBool(false);
  final _accounts = RxMap<String, LoginResponse>({});

  set multipleLogin(bool value) {
    _multipleLogin.value = value;
    StorageService.set('multipleLogin', value);
  }

  bool get multipleLogin => _multipleLogin.value;

  set accessToken(String? value) {
    _accessToken.value = value;
    StorageService.set('accessToken', value);
  }

  String? get accessToken => _accessToken.value;

  set refreshToken(String? value) {
    _refreshToken.value = value;
    StorageService.set('refreshToken', value);
  }

  String? get refreshToken => _refreshToken.value;

  set userId(String? value) {
    _userId.value = value;
    StorageService.set('userId', value);
  }

  String? get userId => _userId.value;

  set token(TokenModel? value) {
    _token.value = value;
    StorageService.set('token', value);
  }

  Map<String, LoginResponse> get accounts => _accounts.value;

  AuthController({multipleLogin = false}) {
    this.multipleLogin = multipleLogin;
  }

  @override
  void onInit() {
    super.onInit();

    StorageService.controller(key: 'multipleLogin', value: _multipleLogin);
    StorageService.controller(key: 'accessToken', value: _accessToken);
    StorageService.controller(key: 'refreshToken', value: _refreshToken);
    StorageService.controller(key: 'userId', value: _userId);
    StorageService.controller<Map<String, LoginResponse>,
            RxMap<String, LoginResponse>>(
        key: 'accounts',
        value: _accounts,
        fromJson: (json) {
          return Map<String, LoginResponse>.from(json.map(
              (key, value) => MapEntry(key, LoginResponse.fromJson(value))));
        },
        toJson: (value) =>
            value.map((key, value) => MapEntry(key, value.toJson())));
  }

  bool isLogin() {
    return accessToken != null;
  }

  TokenModel? get token => _token.value;

  Future<void> logout() async {
    token = null;
    await GoogleService.signOut();
    final userController = Get.find<UserController>();
    userController.user = null;
    accessToken = null;
    refreshToken = null;
    userId = null;
  }

  Future<void> logoutTemporary() async {
    token = null;
    final userController = Get.find<UserController>();
    userController.user = null;
    accessToken = null;
    refreshToken = null;
    userId = null;
  }

  Future<void> _addAccount(LoginResponse res) async {
    accessToken = res.token.accessToken;
    refreshToken = res.token.refreshToken;
    userId = res.user.id;
    _accounts[res.user.id] = res;
    final userController = Get.find<UserController>();
    userController.user = res.user;
  }

  Future<bool> loginWithGoogle() async {
    final user = await AuthService.signInWithGoogle();

    final loginResponse = LoginResponse.fromJson(user);
    if (user != null) {
      _addAccount(loginResponse);
      return true;
    }
    return false;
  }

  Future<bool> loginWithApple() async {
    final user = await AuthService.signInWithApple();
    final loginResponse = LoginResponse.fromJson(user);
    if (user != null) {
      _addAccount(loginResponse);

      return true;
    }
    return false;
  }
}
