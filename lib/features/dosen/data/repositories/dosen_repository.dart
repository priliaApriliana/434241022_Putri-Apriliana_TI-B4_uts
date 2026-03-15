import 'package:dio/dio.dart';
import 'package:app_mobile/features/dosen/data/models/dosen_model.dart';

class DosenRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    headers: {'Accept': 'application/json'},
  ));

  Future<List<DosenModel>> getDosenList() async {
    try {
      final response = await _dio.get('/users');
      final List<dynamic> data = response.data;
      return data.map((json) => DosenModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('DioError: ${e.message}');
    }
  }
}