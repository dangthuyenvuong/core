import 'package:core/http.dart';

class UserServiceBase {
  Future<void> updateUser({
    String? full_name,
    String? avatar,
    String? account_id,
  }) async {
    final response = await Http.put('/user/v1/profile', body: {
      'full_name': full_name,
      'avatar': avatar,
      'account_id': account_id,
    });
    return response;
  }
}

var UserService = UserServiceBase();
