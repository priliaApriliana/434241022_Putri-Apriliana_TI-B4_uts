import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final _authService = Get.find<AuthService>();

  UserModel? get user => _authService.currentUser.value;

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(Routes.login);
  }
}

