import 'package:app_mobile/features/mahasiswa/data/models/mahasiswa_model.dart';

class MahasiswaRepository {
  Future<List<MahasiswaModel>> getMahasiswaList() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      MahasiswaModel(
        nama: 'Putri Apriliana',
        nim: '434241022',
        email: 'putri.apriliana@example.com',
        jurusan: 'Teknik Informatika',
        semester: '4',
      ),
      MahasiswaModel(
        nama: 'Angelyna Rahma',
        nim: '434241006',
        email: 'angelyna.rahma@example.com',
        jurusan: 'Teknik Informatika',
        semester: '4',
      ),
      MahasiswaModel(
        nama: 'Drefita Putri',
        nim: '2021003',
        email: 'drefita.putri@example.com',
        jurusan: 'Teknik Informatika',
        semester: '4',
      ),
      MahasiswaModel(
        nama: 'Zelvia Rani',
        nim: '2021004',
        email: 'zelvia.rani@example.com',
        jurusan: 'Teknik Informatika',
        semester: '4',
      ),
      MahasiswaModel(
        nama: 'Cledyan Basyasyah',
        nim: '434241000',
        email: 'cledyan.basyasyah@example.com',
        jurusan: 'Teknik Informatika',
        semester: '4',
      ),
    ];
  }
}