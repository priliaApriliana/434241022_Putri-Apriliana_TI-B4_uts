import 'package:app_mobile/features/mahasiswa_aktif/data/models/mahasiswa_aktif_model.dart';

class MahasiswaAktifRepository {
  Future<List<MahasiswaAktifModel>> getMahasiswaAktifList() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      MahasiswaAktifModel(
        nama: 'Putri Apriliana',
        nim: '2434241022',
        email: 'putri.apriliana@example.com',
        jurusan: 'Teknik Informatika',
        semester: '4',
        status: 'Aktif',
      ),
      MahasiswaAktifModel(
        nama: 'Angelyna Rahma',
        nim: '434241006',
        email: 'angelyna.rahma@example.com',
        jurusan: 'Teknik Informatika',
        semester: '4',
        status: 'Aktif',
      ),
      MahasiswaAktifModel(
        nama: 'Cledyan Basyasyah',
        nim: '424241000',
        email: 'cledyan.basyasyah@example.com',
        jurusan: 'Teknik Informatika',
        semester: '4',
        status: 'Aktif',
      ),
    ];
  }
}