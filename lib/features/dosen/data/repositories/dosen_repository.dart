// ===============================
// modul 5
// ===============================
// import 'package:dio/dio.dart';
// import 'package:app_mobile/features/dosen/data/models/dosen_model.dart';

// class DosenRepository {
//   final Dio _dio = Dio(BaseOptions(
//     baseUrl: 'https://jsonplaceholder.typicode.com',
//     headers: {'Accept': 'application/json'},
//   ));

//   Future<List<DosenModel>> getDosenList() async {
//     try {
//       final response = await _dio.get('/users');
//       final List<dynamic> data = response.data;
//       return data.map((json) => DosenModel.fromJson(json)).toList();
//     } on DioException catch (e) {
//       throw Exception('DioError: ${e.message}');
//     }
//   }
// }

// ===========================================
// TM 6 - MODUL 6 (local n offline first)
// ===========================================
import 'package:app_mobile/core/network/dio_client.dart';
import 'package:app_mobile/features/dosen/data/models/dosen_model.dart';
import 'package:dio/dio.dart';

class DosenRepository {
  final DioClient _dioClient;

  DosenRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  // get data daftar dosen dari API
  Future<List<DosenModel>> getDosenList() async {
    try {
      final Response response = await _dioClient.dio.get('/users');
      final List<dynamic> data = response.data;
      return data.map((json) => DosenModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(
        'Gagal memuat data dosen: ${e.response?.statusCode} - ${e.message}',
      );
    }
  }
}