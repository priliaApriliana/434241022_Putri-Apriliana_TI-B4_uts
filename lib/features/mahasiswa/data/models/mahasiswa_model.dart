class MahasiswaModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final MahasiswaAddress address;
  final String phone;
  final String website;

  MahasiswaModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
  });

  factory MahasiswaModel.fromJson(Map<String, dynamic> json) {
    return MahasiswaModel(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      address: MahasiswaAddress.fromJson(
          json['address'] as Map<String, dynamic>),
      phone: json['phone'] as String,
      website: json['website'] as String,
    );
  }
}

class MahasiswaAddress {
  final String city;
  final String street;

  MahasiswaAddress({required this.city, required this.street});

  factory MahasiswaAddress.fromJson(Map<String, dynamic> json) {
    return MahasiswaAddress(
      city: json['city'] as String,
      street: json['street'] as String,
    );
  }
}