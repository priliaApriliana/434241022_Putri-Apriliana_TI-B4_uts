import 'dart:io';

// class Mahasiswa {
//     String nama = "Putri";

//     void tampilkanData() {
//       print(nama);
//     }
// }

// void main() {
//   var mahasiswa1 = Mahasiswa();
//   mahasiswa1.tampilkanData();

//   stdout.write("Masukkan nama baru : ");
//   String? namaBaru = stdin.readLineSync();
//   if (namaBaru != null && namaBaru.isNotEmpty) {
//     mahasiswa1.nama= namaBaru;
//     print("Nama berhasil diubah. ");
//     mahasiswa1.tampilkanData();
//   } else {
//     print("Nama tidak boleh kosong.");
//   }
// }

class Mahasiswa {
  String? nama;
  int? nim;
  String? jurusan;

  void tampilkanData() {
    print("Nama: ${nama ??  'Belum diisi'}");
    print("NIM : ${nim ?? 'Belum diisi'}");
    print("Jurusan : ${jurusan ?? 'Belum diisi'}");
  }
}

// ================= EXTENDS =================

class MahasiswaAktif extends Mahasiswa {
  int? semester;

  @override
  void tampilkanData() {
    print("==== Data Mahasiswa Aktif ====");
    super.tampilkanData();
    print("Semester : ${semester ?? 'Belum diisi'}");
  }
}

class MahasiswaAlumni extends Mahasiswa {
  int? tahunLulus;

  @override
  void tampilkanData() {
    print("==== Data Mahasiswa Alumni ====");
    super.tampilkanData();
    print("Tahun Lulus : ${tahunLulus ?? 'Belum diisi'}");
  }
}

// ================= MIXIN =================

mixin Presensi {
  void catatKehadiran() {
    print("Kehadiran dicatat.");
  }
}

mixin Penilaian {
  void beriNilai() {
    print("Nilai berhasil diberikan.");
  }
}

mixin InformasiAkademik {
  void infoAkademik() {
    print("Informasi akademik tersedia.");
  }
}

// ================= IMPLEMENTASI MIXIN =================

class Dosen extends Mahasiswa with Presensi, Penilaian {
  String? nip;

  void infoDosen() {
    print("=== Data Dosen ===");
    print("NIP : ${nip ?? 'Belum diisi'}");
    catatKehadiran();
    beriNilai();
  }
}

class Fakultas extends Mahasiswa with InformasiAkademik {
  String? namaFakultas;

  void infoFakultas() {
    print("=== Data Fakultas ===");
    print("Nama Fakultas : ${namaFakultas ?? 'Belum diisi'}");
    infoAkademik();
  }
}

// ================= MAIN =================

void main() {
  print("TESTING EXTENDS\n");

  var mhsAktif = MahasiswaAktif();
  mhsAktif.nama = "Putri";
  mhsAktif.nim = 434241022;
  mhsAktif.jurusan = "Informatika";
  mhsAktif.semester = 4;
  mhsAktif.tampilkanData();

  print("\n");

  var alumni = MahasiswaAlumni();
  alumni.nama = "April";
  alumni.nim = 412241010;
  alumni.jurusan = "Sistem Informasi";
  alumni.tahunLulus = 2023;
  alumni.tampilkanData();

  print("\nTESTING MIXIN\n");

  var dosenTI = Dosen();
  dosenTI.nip = "198801012024";
  dosenTI.infoDosen();

  print("\n---\n");

  var fakultasTI = Fakultas();
  fakultasTI.namaFakultas = "Fakultas Teknik";
  fakultasTI.infoFakultas();
}
