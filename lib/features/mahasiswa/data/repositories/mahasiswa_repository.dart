// ====================================
// TM 4 - MODUL 4
// ====================================

// import 'package:app_mobile/features/mahasiswa/data/models/mahasiswa_model.dart';

// class MahasiswaRepository {
//   Future<List<MahasiswaModel>> getMahasiswaList() async {
//     await Future.delayed(const Duration(seconds: 1));

//     return [
//       MahasiswaModel(
//         nama: 'Putri Apriliana',
//         nim: '434241022',
//         email: 'putri.apriliana@example.com',
//         jurusan: 'Teknik Informatika',
//         semester: '4',
//       ),
//       MahasiswaModel(
//         nama: 'Angelyna Rahma',
//         nim: '434241006',
//         email: 'angelyna.rahma@example.com',
//         jurusan: 'Teknik Informatika',
//         semester: '4',
//       ),
//       MahasiswaModel(
//         nama: 'Drefita Putri',
//         nim: '2021003',
//         email: 'drefita.putri@example.com',
//         jurusan: 'Teknik Informatika',
//         semester: '4',
//       ),
//       MahasiswaModel(
//         nama: 'Zelvia Rani',
//         nim: '2021004',
//         email: 'zelvia.rani@example.com',
//         jurusan: 'Teknik Informatika',
//         semester: '4',
//       ),
//       MahasiswaModel(
//         nama: 'Cledyan Basyasyah',
//         nim: '434241000',
//         email: 'cledyan.basyasyah@example.com',
//         jurusan: 'Teknik Informatika',
//         semester: '4',
//       ),
//     ];
//   }
// }

// ====================================
// http 
// ====================================

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:app_mobile/features/mahasiswa/data/models/mahasiswa_model.dart';

// class MahasiswaRepository {
//   Future<List<MahasiswaModel>> getMahasiswaList() async {
//     final response = await http.get(
//       Uri.parse('https://jsonplaceholder.typicode.com/comments'),
//       headers: {'Accept': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       return data.map((json) => MahasiswaModel.fromJson(json)).toList();
//     } else {
//       throw Exception('Gagal memuat data mahasiswa: ${response.statusCode}');
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:app_mobile/features/mahasiswa/data/models/mahasiswa_model.dart';

class MahasiswaRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    headers: {'Accept': 'application/json'},
  ));

  Future<List<MahasiswaModel>> getMahasiswaList() async {
    try {
      final response = await _dio.get('/comments');
      final List<dynamic> data = response.data;
      return data.map((json) => MahasiswaModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('DioError: ${e.message}');
    }
  }
}