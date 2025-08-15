import 'package:core/models/user/model.dart';
import 'package:core/services/storage.service.dart';
import 'package:core/services/user.service.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final _user = Rx<UserModel?>(null);

  set user(UserModel? value) {
    _user.value = value;
    StorageService.set('user', value);
  }

  UserModel? get user => _user.value;

  void loadUser() {
    final user = StorageService.get('user');
    if (user != null) {
      this.user = UserModel.fromJson(user);
    }
  }

  Future<void> updateUser({
    String? full_name,
    String? avatar,
    String? account_id,
  }) async {
    if (user == null) return;
    user = user!.copyWith(
      full_name: full_name ?? user!.full_name,
      avatar: avatar ?? user!.avatar,
      account_id: account_id ?? user!.account_id,
    );
    UserService.updateUser(
      full_name: full_name ?? user!.full_name,
      avatar: avatar ?? user!.avatar,
      account_id: account_id ?? user!.account_id,
    );
  }
}
