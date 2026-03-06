import 'dart:io';

void main() {
  // membuat set dengan data awal
  Set<String> burung  = {'Merpati', 'Elang', 'Kakatua'};
  print('Burung: $burung');

  // menambahkan data
  burung.add('Cendrawasih');
  print('Setelah tambah data: $burung');

  // tambah data duplicate
  burung.add('Elang'); // duplicate
  print('Setelah tambah data yang duplicate: $burung');

  //hapus data
  burung.remove('Kakatua');
  print('Setelah menghapus data: $burung');

  // ngecek data tertentu
  print('Apakah ada burung Elang? ${burung.contains('Elang')}');
  print('Apakah ada burung Jalak Bali? ${burung.contains('Jalak Bali')}');

  // hitung jumlah data
  print('Jumlah data dalam set: ${burung.length}');

  //hasil akhir
  print('=== SEMUA DATA ===');
  int no = 1;
  for (var item in burung) {
    print('$no. $item');
    no++;
  }
}