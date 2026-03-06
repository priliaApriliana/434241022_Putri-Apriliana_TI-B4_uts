// import 'dart:io';
//
// void main() {
//   // membuat map dengan data awal
//   Map<String, String> data = {
//     'Putri' : '081234567890',
//     'Anggel' : '082345678901',
//     'Putnjel' : '083456789012',
//   };
//   print('Data: $data');
//
//   // menambahkan data ke map
//   data['Lailia'] = '08456789012';
//   print('Data setelah ditambahkan: $data');
//
//   // mengakases data berdasrkan key
//   print('Nomor Putri: ${data['Putri']}');
//
//   //ubah data
//   data['Putri']= '08000001';
//   print('Data setelah diubah: $data');
//
//   // hapus data
//   data.remove('Lailia');
//   print('Data telah dihapus: $data');
//
//   // cek data berdasarkan key
//   stdout.write("Masukkan nama (key) yang ingin dicek: ");
//   String cekKey = stdin.readLineSync()!;
//
//   if (data.containsKey(cekKey)) {
//     print('Key "$cekKey" ditemukan dengan nomor: ${data[cekKey]}');
//   } else {
//     print('Key "$cekKey" tidak ditemukan!');
//   }
//
//   //hitung jumlah data
//   print('Jumlah data: ${data.length}');
//
//   // semua key
//   print('Semua key: ${data.keys}');
//
//   //semua value
//   print('Semua value: ${data.values}');
// }
  // sigle
  import 'dart:io';

  void main() {
    print("=== INPUT DATA MAHASISWA ===");

    stdout.write("Masukkan NIM: ");
    String nim = stdin.readLineSync()!;

    stdout.write("Masukkan Nama: ");
    String nama = stdin.readLineSync()!;

    stdout.write("Masukkan Jurusan: ");
    String jurusan = stdin.readLineSync()!;

    stdout.write("Masukkan IPK: ");
    String ipk = stdin.readLineSync()!;

    Map<String, String> mahasiswa = {
      'nim': nim,
      'nama': nama,
      'jurusan': jurusan,
      'ipk': ipk,
    };

    print("Data Mahasiswa: $mahasiswa");

    print("=== INPUT MULTIPLE MAHASISWA ===");

    stdout.write("Masukkan jumlah mahasiswa: ");
    int jumlah = int.parse(stdin.readLineSync()!);

    List<Map<String, String>> listMahasiswa = [];

    for (int i = 0; i < jumlah; i++) {
      print("--- Mahasiswa ke-${i + 1} ---");

      stdout.write("Masukkan NIM: ");
      String nim = stdin.readLineSync()!;

      stdout.write("Masukkan Nama: ");
      String nama = stdin.readLineSync()!;

      stdout.write("Masukkan Jurusan: ");
      String jurusan = stdin.readLineSync()!;

      stdout.write("Masukkan IPK: ");
      String ipk = stdin.readLineSync()!;

      listMahasiswa.add({
        'nim': nim,
        'nama': nama,
        'jurusan': jurusan,
        'ipk': ipk,
      });
    }

    print("=== DATA SEMUA MAHASISWA ===");
    for (var mhs in listMahasiswa) {
      print(mhs);
    }
  }
