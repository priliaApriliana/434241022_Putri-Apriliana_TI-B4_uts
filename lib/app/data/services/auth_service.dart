import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/user_model.dart';

class AuthService extends GetxService {
  final _box = GetStorage();
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': '1',
      'name': 'Budi Admin',
      'email': 'admin@test.com',
      'password': '123456',
      'role': 'admin',
      'avatar': null,
    },
    {
      'id': '2',
      'name': 'Siti Helpdesk',
      'email': 'helpdesk@test.com',
      'password': '123456',
      'role': 'helpdesk',
      'avatar': null,
    },
    {
      'id': '3',
      'name': 'Andi User',
      'email': 'user@test.com',
      'password': '123456',
      'role': 'user',
      'avatar': null,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  void _loadUser() {
    final userData = _box.read('user');
    if (userData != null) {
      currentUser.value = UserModel.fromJson(Map<String, dynamic>.from(userData));
    }
  }

  bool get isLoggedIn => currentUser.value != null;

  List<UserModel> get assignableUsers {
    return _mockUsers
        .where((user) => user['role'] == 'helpdesk' || user['role'] == 'admin')
        .map((user) => UserModel.fromJson(Map<String, dynamic>.from(user)))
        .toList();
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final user = _mockUsers.firstWhereOrNull(
      (u) => u['email'] == email && u['password'] == password,
    );

    if (user == null) {
      return {'success': false, 'message': 'Email atau password salah'};
    }

    final userModel = UserModel.fromJson(user);
    currentUser.value = userModel;
    _box.write('user', userModel.toJson());
    _box.write('token', 'mock_token_${user['id']}');

    return {'success': true, 'user': userModel};
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final exists = _mockUsers.any((u) => u['email'] == email);
    if (exists) {
      return {'success': false, 'message': 'Email sudah terdaftar'};
    }

    _mockUsers.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'email': email,
      'password': password,
      'role': 'user',
      'avatar': null,
    });

    return {'success': true, 'message': 'Registrasi berhasil, silakan login'};
  }

  Future<void> logout() async {
    currentUser.value = null;
    _box.remove('user');
    _box.remove('token');
  }
}
