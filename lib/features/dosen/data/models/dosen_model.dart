// ===========================================
// TM 4 - MODUL 4
// ===========================================

// class DosenModel {
//   final String nama;
//   final String nip;
//   final String email;
//   final String jurusan;

//   DosenModel({
//     required this.nama,
//     required this.nip,
//     required this.email,
//     required this.jurusan,
//   });

//   factory DosenModel.fromJson(Map<String, dynamic> json) {
//     return DosenModel(
//       nama: json['nama'] ?? '',
//       nip: json['nip'] ?? '',
//       email: json['email'] ?? '',
//       jurusan: json['jurusan'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'nama': nama,
//       'nip': nip,
//       'email': email,
//       'jurusan': jurusan,
//     };
//   }
// }

// ===========================================
// TM 5 - MODUL 5 (API n Http client)
// ===========================================

class AddressModel {
  final String street;
  final String suite;
  final String city;
  final String zipCode;

  AddressModel({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipCode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json['street'] ?? '',
      suite: json['suite'] ?? '',
      city: json['city'] ?? '',
      zipCode: json['zipCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'suite': suite,
      'city': city,
      'zipCode': zipCode,
    };
  }
}

class DosenModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final AddressModel address;

  DosenModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
  });

  factory DosenModel.fromJson(Map<String, dynamic> json) {
    return DosenModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      address: AddressModel.fromJson(json['address'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'address': address.toJson(),
    };
  }
}