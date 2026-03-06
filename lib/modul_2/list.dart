import 'dart:io';

void main() {
  List<String> names = ["alfa", "beta", "charlie"];
  print("Names: $names");

  // menambahkan data dalam list
  names.add('Delta');
  print('Names setelah ditambahkan: $names');

  // mengambil data index tertentu
  print('elemen pertama: ${names[0]}');
  print('elemen kedua: ${names[1]}');

  // mengubah data index tertentu
  names[1] = 'Bravo';
  print('Names setelah diubah; $names');

  // menghapus data dari list
  names.remove('charlie');
  print('Names setelah dihapus; $names');

  // menghitung jumlah data dalam list
  print('Jumlah data; ${names.length}');

  // looping data list
  print('Menampilkan setiap elemen:');
  for (String name in names) {
    print(name);
  }

  // membuat list kosong
  List<String> dataList = [];
  print('Data list kosong: $dataList');

  // mengambil jumlah data dari pengguna
  int count = 0;
  while (count <= 0) {
    stdout.write('Masukkan jumlah list: ');
    String? input = stdin.readLineSync();
    try {
      count = int.parse(input!);
      if (count <= 0) {
        print('Masukkan angka lebih dari 0!');
      }
    } catch (e) {
      print('Input tidak valid! Masukkan angka yang benar.');
    }
  }

  // memasukkan data ke dalam list menggunakan for loop
  for (int i = 0; i < count; i++) {
    stdout.write('data ke-${i + 1}: ');
    String x = stdin.readLineSync()!;
    dataList.add(x);
  }

  // Menampilkan data list
  print('Data list:');
  print(dataList);

  print('Data yang sudah di masukkan: $dataList');

  //m. tampil berdasarkan index tertentu
  stdout.write('Masukkan index yang ingin ditampilkan: ');
  int indexTampil = int.parse(stdin.readLineSync()!);

  if (indexTampil >= 0 && indexTampil < dataList.length) {
    print('Data pada index $indexTampil: ${dataList[indexTampil]}');
  } else {
    print('Index tidak valid!');
  }

  // ubah berdasarkan index
  stdout.write('Masukkan index yang ingin diubah: ');
  int indexUbah = int.parse(stdin.readLineSync()!);

  if (indexUbah >= 0 && indexUbah < dataList.length) {
    stdout.write('Masukkan data baru: ');
    String dataBaru = stdin.readLineSync()!;
    dataList[indexUbah] = dataBaru;
    print('Data setelah diubah: $dataList');
  } else {
    print('Index tidak valid!');
  }

  // hapus berdasarkan index
  stdout.write('Masukkan index yang ingin dihapus: ');
  int indexHapus = int.parse(stdin.readLineSync()!);

  if (indexHapus >= 0 && indexHapus < dataList.length) {
    dataList.removeAt(indexHapus);
    print('Data setelah dihapus: $dataList');
  } else {
    print('Index tidak valid!');
  }

  // tampilkan hasil akhir
  print('=== SEMUA DATA ===');
  for (int i = 0; i < dataList.length; i++) {
    print('Index $i: ${dataList[i]}');
  }
}






