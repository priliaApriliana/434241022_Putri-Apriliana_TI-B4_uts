import 'package:app_mobile/core/network/dio_client.dart';
import 'package:app_mobile/features/mahasiswa/data/models/mahasiswa_model.dart';
import 'package:dio/dio.dart';

class MahasiswaRepository {
  final DioClient _dioClient;

  MahasiswaRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  Future<List<MahasiswaModel>> getMahasiswaList() async {
    try {
      final Response response = await _dioClient.dio.get('/users');
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) =>
              MahasiswaModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        'Gagal memuat data mahasiswa: ${e.response?.statusCode} - ${e.message}',
      );
    }
  }
}