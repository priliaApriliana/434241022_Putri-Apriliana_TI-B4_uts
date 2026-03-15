import 'package:app_mobile/features/profile/data/models/profile_model.dart';

class ProfileRepository {
  Future<ProfileModel> getProfile() async {
    // Data dummy profile
    return ProfileModel(
      name: 'Mahasiswa D4TI',
      email: 'mahasiswa@example.com',
      phone: '08123456789',
      address: 'Surabaya, Jawa Timur',
    );
  }
}