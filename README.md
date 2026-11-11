# RuangTuntas

**Aplikasi Manajemen Tugas Kuliah Berbasis Flutter**

## 1. Identitas Mahasiswa

- Nama: Indah Susanti
- NIM: 2415051079
- Kelas: PRI 5C
- Mata Kuliah: Pemrograman Berbasis Mobile
## 2. Deskripsi Aplikasi

RuangTuntas adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu mahasiswa mengelola tugas kuliah secara lebih terorganisir.

Aplikasi ini memungkinkan pengguna menambahkan, melihat, mengubah, menghapus, dan memantau status penyelesaian tugas. Aplikasi menggunakan Supabase sebagai backend dan REST API untuk menampilkan kutipan motivasi.

## 3. Fitur Aplikasi

- Dashboard ringkasan tugas.
- Menambahkan tugas baru.
- Menampilkan daftar tugas.
- Melihat detail tugas.
- Mengedit data tugas.
- Menghapus tugas.
- Mengubah status penyelesaian tugas.
- Menyimpan data menggunakan Supabase.
- Menampilkan kutipan motivasi dari REST API.
- Menampilkan loading, error, dan empty state.

## 4. Teknologi yang Digunakan

- Flutter
- Dart
- Supabase
- Provider
- HTTP
- DummyJSON REST API
- Material Design 3

## 5. REST API

Aplikasi menggunakan DummyJSON untuk mengambil kutipan motivasi secara acak.

Endpoint:

`https://dummyjson.com/quotes/random`

Data JSON diproses untuk menampilkan kutipan dan nama penulis pada dashboard aplikasi.

## 6. Backend dan Database

Aplikasi RuangTuntas menggunakan Supabase sebagai backend dan database untuk menyimpan serta mengelola data tugas.

Operasi database yang digunakan meliputi:

- Create: menambahkan tugas.
- Read: menampilkan data tugas.
- Update: mengubah data tugas.
- Delete: menghapus tugas.

Konfigurasi Supabase menggunakan file `supabase_config.json` dengan parameter `--dart-define-from-file`.

Catatan keamanan: File konfigurasi yang berisi kredensial tidak boleh diunggah ke repository publik.

## 7. Struktur Folder Project

Struktur utama project:

```text
lib/
├── config/
├── models/
├── providers/
├── repositories/
├── screens/
├── services/
├── widgets/
└── main.dart
```

Keterangan:

- `config`: konfigurasi aplikasi.
- `models`: struktur model data.
- `providers`: pengelolaan state aplikasi.
- `repositories`: pengelolaan akses data.
- `screens`: halaman aplikasi.
- `services`: layanan komunikasi dengan backend.
- `widgets`: komponen antarmuka yang dapat digunakan kembali.

## 8. Cara Menjalankan Aplikasi

Persyaratan:
- Flutter SDK.
- Dart SDK.
- Android Studio atau Android Emulator.
- Koneksi internet.
- Konfigurasi Supabase yang valid.

Langkah menjalankan:

1. Clone repository:

   `git clone https://github.com/ndahahah/RuangTuntas.git`

2. Masuk ke folder project.

3. Instal dependencies:

   `flutter pub get`

4. Siapkan file `supabase_config.json` dengan konfigurasi Supabase yang valid.

5. Jalankan aplikasi:

   `flutter run --dart-define-from-file=supabase_config.json`

## 9. Pengujian Aplikasi

Pengujian yang telah dilakukan pada aplikasi RuangTuntas meliputi:

- Flutter Analyze: berhasil tanpa masalah.
- Flutter Test: seluruh pengujian berhasil.
- Build APK Release: berhasil.
- Pengujian tambah tugas: berhasil.
- Pengujian edit tugas: berhasil.
- Pengujian hapus tugas: berhasil.
- Pengujian penyimpanan data: berhasil.
- Pengujian koneksi Supabase: berhasil.
- Pengujian REST API: berhasil.

## 10. Build APK Release

Untuk membuat APK release, jalankan perintah:

```bash
flutter build apk --release --dart-define-from-file=supabase_config.json
```

Lokasi APK:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## 11. Screenshot Aplikasi

Screenshot yang perlu dilampirkan:

1. Dashboard.
2. Daftar tugas.
3. Detail tugas.
4. Form tambah tugas.
5. Form edit tugas.
6. Tampilan responsif.

Simpan screenshot di folder `screenshots/`.

## 12. Repository GitHub

Repository project:

https://github.com/ndahahah/RuangTuntas

---

**RuangTuntas — Kelola Tugas, Raih Tuntas.**

