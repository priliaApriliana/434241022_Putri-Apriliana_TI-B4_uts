// =======================================
// modul 4 - TM 4
// =======================================

// import 'package:app_mobile/features/mahasiswa_aktif/data/models/mahasiswa_aktif_model.dart';

// class MahasiswaAktifRepository {
//   Future<List<MahasiswaAktifModel>> getMahasiswaAktifList() async {
//     await Future.delayed(const Duration(seconds: 1));

//     return [
//       MahasiswaAktifModel(
//         nama: 'Putri Apriliana',
//         nim: '2434241022',
//         email: 'putri.apriliana@example.com',
//         jurusan: 'Teknik Informatika',
//         semester: '4',
//         status: 'Aktif',
//       ),
//       MahasiswaAktifModel(
//         nama: 'Angelyna Rahma',
//         nim: '434241006',
//         email: 'angelyna.rahma@example.com',
//         jurusan: 'Teknik Informatika',
//         semester: '4',
//         status: 'Aktif',
//       ),
//       MahasiswaAktifModel(
//         nama: 'Cledyan Basyasyah',
//         nim: '424241000',
//         email: 'cledyan.basyasyah@example.com',
//         jurusan: 'Teknik Informatika',
//         semester: '4',
//         status: 'Aktif',
//       ),
//     ];
//   }
// }

// ====================================
// http
// ====================================

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:app_mobile/features/mahasiswa_aktif/data/models/mahasiswa_aktif_model.dart';

// class MahasiswaAktifRepository {
//   Future<List<MahasiswaAktifModel>> getMahasiswaAktifList() async {
//     final response = await http.get(
//       Uri.parse('https://jsonplaceholder.typicode.com/posts'),
//       headers: {'Accept': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       return data.map((json) => MahasiswaAktifModel.fromJson(json)).toList();
//     } else {
//       throw Exception('Gagal memuat data: ${response.statusCode}');
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:app_mobile/features/mahasiswa_aktif/data/models/mahasiswa_aktif_model.dart';

class MahasiswaAktifRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    headers: {'Accept': 'application/json'},
  ));

  Future<List<MahasiswaAktifModel>> getMahasiswaAktifList() async {
    try {
      final response = await _dio.get('/posts');
      final List<dynamic> data = response.data;
      return data.map((json) => MahasiswaAktifModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('DioError: ${e.message}');
    }
  }
}