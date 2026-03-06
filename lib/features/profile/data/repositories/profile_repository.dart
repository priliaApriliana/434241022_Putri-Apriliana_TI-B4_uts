import 'package:app_mobile/features/dosen/data/models/dosen_model.dart';

class DosenRepository {
  Future<List<DosenModel>> getDosenList() async {
    // Simsimulasi delay network
    await Future.delayed(const Duration(seconds: 1));

    // Data dummy dosen
    return [
      DosenModel(
        nama: 'Dr. Andi Wijaya',
        nip: '123456789',
        email: 'andi.wijaya@example.com',
        jurusan: 'Teknik Informatika',
      ),
        DosenModel(
            nama: 'Dr. Siti Nurhaliza',
            nip: '987654321',
            email: 'siti.nurhaliza@example.com',
            jurusan: 'Manajemen',
        ),

        DosenModel(
            nama: 'Dr. Budi Santoso',
            nip: '456789123',
            email: 'budi.santoso@example.com',
            jurusan: 'Sistem Informasi',
        ),
    ];
  }
}