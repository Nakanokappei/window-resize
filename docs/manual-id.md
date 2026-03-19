# Window Resize — Panduan Pengguna

## Daftar Isi

1. [Pengaturan Awal](#pengaturan-awal)
2. [Snap Resize](#snap-resize)
3. [Pengaturan](#pengaturan)
4. [Pemecahan Masalah](#pemecahan-masalah)

---

## Pengaturan Awal

### Memberikan Izin Aksesibilitas

Window Resize menggunakan API Aksesibilitas macOS untuk mendeteksi dan mengubah ukuran jendela. Anda harus memberikan izin saat pertama kali meluncurkan aplikasi.

1. Jalankan **Window Resize**. Dialog sistem akan muncul meminta Anda untuk memberikan akses Aksesibilitas.
2. Klik **"Buka Pengaturan Sistem"** (atau buka secara manual ke **Pengaturan Sistem > Privasi & Keamanan > Aksesibilitas**).
3. Temukan **"Window Resize"** di daftar dan aktifkan sakelarnya.
4. Kembali ke aplikasi — ikon bilah menu akan muncul dan aplikasi siap digunakan.

> **Catatan:** Jika dialog tidak muncul, Anda dapat membuka pengaturan Aksesibilitas langsung dari jendela Pengaturan aplikasi (lihat [Status Aksesibilitas](#status-aksesibilitas)).

---

## Snap Resize

### Cara Kerja

Window Resize memantau operasi pengubahan ukuran jendela secara waktu nyata. Saat Anda menarik tepi atau sudut jendela untuk mengubah ukurannya, aplikasi mendeteksi seberapa dekat dimensi jendela dengan ukuran preset yang tersedia.

1. **Mulai mengubah ukuran** — tarik tepi atau sudut jendela mana pun seperti biasa.
2. **Overlay muncul** — saat ukuran jendela mendekati sebuah preset (dalam jarak 30 piksel), overlay berbatas berwarna akan muncul di sekeliling jendela yang menunjukkan ukuran preset target.
3. **Lepaskan untuk snap** — lepaskan mouse dan jendela akan langsung menyesuaikan ke ukuran preset tersebut secara presisi.
4. **Batalkan** — jika Anda menggerakkan ukuran jendela menjauhi preset sebelum melepaskan, overlay menghilang dan tidak ada snap yang terjadi.

### Tampilan Rasio Aspek

Selama mengubah ukuran, rasio aspek saat ini ditampilkan di overlay. Jika rasio tersebut sesuai dengan proporsi yang dikenal, namanya akan ditampilkan:

- **Rasio Emas** (1,618:1)
- **Rasio Perak** (2,414:1)
- **Rasio Platinum** (1,325:1)
- **Rasio Perunggu** (3,303:1)

Rasio lainnya ditampilkan sebagai pecahan sederhana (misalnya, "16:9", "4:3").

> Fitur ini dapat dinonaktifkan di Pengaturan (lihat [Tampilan Overlay](#tampilan-overlay)).

### Shift untuk Mengunci Rasio Aspek

Tahan tombol **Shift** saat mengubah ukuran untuk mengunci rasio aspek. Jendela akan mempertahankan proporsinya saat Anda menarik.

> Fitur ini dapat dinonaktifkan di Pengaturan (lihat [Tampilan Overlay](#tampilan-overlay)).

---

## Pengaturan

Buka Pengaturan dari bilah menu: klik ikon Window Resize, lalu pilih **"Pengaturan..."** (pintasan: **Cmd+,**).

### Ukuran Bawaan

Aplikasi menyertakan 12 ukuran preset bawaan:

| Ukuran | Label |
|--------|-------|
| 2560 x 1600 | MacBook Pro 16" |
| 2560 x 1440 | QHD / iMac |
| 1728 x 1117 | MacBook Pro 14" |
| 1512 x 982 | MacBook Air 15" |
| 1470 x 956 | MacBook Air 13" M3 |
| 1440 x 900 | MacBook Air 13" |
| 1920 x 1080 | Full HD |
| 1680 x 1050 | WSXGA+ |
| 1280 x 800 | WXGA |
| 1280 x 720 | HD |
| 1024 x 768 | XGA |
| 800 x 600 | SVGA |

Ukuran bawaan tidak dapat dihapus atau diedit.

### Ukuran Kustom

Anda dapat menambahkan ukuran sendiri ke daftar:

1. Di bagian **"Kustom"**, masukkan **Lebar** dan **Tinggi** dalam piksel.
2. Klik **"Tambah"**.
3. Ukuran baru langsung tersedia untuk deteksi snap saat mengubah ukuran.

Untuk menghapus ukuran kustom, klik tombol **"Hapus"** berwarna merah di sebelahnya.

### Tampilan Overlay

Atur gaya visual overlay snap:

- **Batas resize** — warna dan gaya garis batas (solid atau putus-putus) yang ditampilkan saat mengubah ukuran mendekati sebuah preset. Default: oranye, putus-putus.
- **Batas snap** — warna dan gaya garis batas yang ditampilkan saat jendela di-snap ke sebuah preset. Default: oranye, solid.
- **Tampilkan rasio aspek** — aktifkan/nonaktifkan label rasio aspek di overlay. Default: aktif.
- **Shift untuk mengunci rasio** — aktifkan/nonaktifkan penguncian rasio aspek saat menahan Shift saat mengubah ukuran. Default: aktif.

Warna batas yang tersedia: Oranye, Biru, Hijau, Merah, Ungu, Putih.

### Jalankan Saat Login

Aktifkan **"Jalankan Saat Login"** agar Window Resize otomatis berjalan saat Anda masuk ke macOS.

### Bahasa

Pilih bahasa tampilan aplikasi dari dropdown **Bahasa**. Tersedia 16 bahasa atau **"Bawaan Sistem"** untuk mengikuti bahasa sistem macOS. Perubahan bahasa memerlukan peluncuran ulang aplikasi.

### Status Aksesibilitas

Di bagian bawah jendela Pengaturan, indikator status menunjukkan kondisi terkini izin Aksesibilitas:

| Indikator | Arti |
|-----------|------|
| Hijau | Izin aktif dan berfungsi dengan benar. |
| Oranye | Sistem melaporkan izin telah diberikan, tetapi tidak lagi berlaku (lihat [Memperbaiki Izin yang Kedaluwarsa](#memperbaiki-izin-yang-kedaluwarsa)). Tombol "Buka Pengaturan" ditampilkan. |
| Merah | Izin belum diberikan. Tombol "Buka Pengaturan" ditampilkan. |

---

## Pemecahan Masalah

### Memperbaiki Izin yang Kedaluwarsa

Jika Anda melihat indikator status berwarna oranye atau pesan "Aksesibilitas: Perlu Diperbarui", izin telah kedaluwarsa. Ini dapat terjadi setelah aplikasi diperbarui atau dibangun ulang.

**Untuk memperbaiki:**

1. Buka **Pengaturan Sistem > Privasi & Keamanan > Aksesibilitas**.
2. Temukan **"Window Resize"** di daftar.
3. Matikan sakelarnya, lalu nyalakan kembali.
4. Alternatif lain, hapus sepenuhnya dari daftar, lalu luncurkan ulang aplikasi untuk menambahkannya kembali.

### Snap Tidak Berfungsi

Jika overlay tidak muncul saat mengubah ukuran:

- Periksa apakah izin Aksesibilitas aktif (indikator hijau di Pengaturan).
- Pastikan jendela yang Anda ubah ukurannya mendukung pengubahan ukuran standar (beberapa aplikasi membatasi pengubahan ukuran jendela).
- Jendela dalam mode layar penuh tidak dapat diubah ukurannya — keluar dari layar penuh terlebih dahulu.

### Masalah Tampilan Jendela Setelah Snap

Dalam kasus yang jarang terjadi, jendela target mungkin tidak digambar ulang dengan benar setelah snap. Aplikasi secara otomatis memaksa penggambaran ulang, tetapi jika artefak visual tetap ada, coba minimalkan dan pulihkan jendela tersebut.
