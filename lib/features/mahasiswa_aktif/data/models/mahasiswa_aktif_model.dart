// =======================================
// modul 4 - TM 4
// =======================================

// class MahasiswaAktifModel {
//   final String nama;
//   final String nim;
//   final String email;
//   final String jurusan;
//   final String semester;
//   final String status;

//   MahasiswaAktifModel({
//     required this.nama,
//     required this.nim,
//     required this.email,
//     required this.jurusan,
//     required this.semester,
//     required this.status,
//   });
// }

class MahasiswaAktifModel {
  final int id;
  final int userId;
  final String title;
  final String body;

  MahasiswaAktifModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory MahasiswaAktifModel.fromJson(Map<String, dynamic> json) {
    return MahasiswaAktifModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }
}