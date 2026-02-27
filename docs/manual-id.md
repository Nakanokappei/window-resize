# Window Resize — Panduan Pengguna

## Daftar Isi

1. [Pengaturan Awal](#pengaturan-awal)
2. [Mengubah Ukuran Jendela](#mengubah-ukuran-jendela)
3. [Pengaturan](#pengaturan)
4. [Pemecahan Masalah](#pemecahan-masalah)

---

## Pengaturan Awal

### Memberikan Izin Aksesibilitas

Window Resize menggunakan API Aksesibilitas macOS untuk mengubah ukuran jendela. Anda harus memberikan izin saat pertama kali meluncurkan aplikasi.

1. Jalankan **Window Resize**. Dialog sistem akan muncul meminta Anda untuk memberikan akses Aksesibilitas.
2. Klik **"Buka Pengaturan"** (atau buka secara manual ke **Pengaturan Sistem > Privasi & Keamanan > Aksesibilitas**).
3. Temukan **"Window Resize"** di daftar dan aktifkan sakelarnya.
4. Kembali ke aplikasi — ikon bilah menu akan muncul dan aplikasi siap digunakan.

> **Catatan:** Jika dialog tidak muncul, Anda dapat membuka pengaturan Aksesibilitas langsung dari jendela Pengaturan aplikasi (lihat [Status Aksesibilitas](#status-aksesibilitas)).

---

## Mengubah Ukuran Jendela

### Langkah demi Langkah

1. Klik **ikon Window Resize** di bilah menu.
2. Arahkan kursor ke **"Ubah Ukuran"** untuk membuka daftar jendela.
3. Semua jendela yang sedang terbuka ditampilkan dengan **ikon aplikasi** dan namanya sebagai **[Nama Aplikasi] Judul Jendela**. Judul yang panjang secara otomatis dipotong agar menu tetap mudah dibaca.
4. Arahkan kursor ke suatu jendela untuk melihat ukuran preset yang tersedia.
5. Klik sebuah ukuran untuk langsung mengubah ukuran jendela.

### Cara Ukuran Ditampilkan

Setiap entri ukuran di menu menampilkan:

```
1920 x 1080          Full HD
```

- **Kiri:** Lebar x Tinggi (dalam piksel)
- **Kanan:** Label (nama perangkat atau nama standar), ditampilkan dalam warna abu-abu

### Ukuran yang Melebihi Layar

Jika ukuran preset lebih besar dari layar tempat jendela berada, ukuran tersebut akan **berwarna abu-abu dan tidak dapat dipilih**. Ini mencegah Anda mengubah ukuran jendela melampaui batas layar.

> **Multi-display:** Aplikasi mendeteksi layar mana yang digunakan setiap jendela dan menyesuaikan ukuran yang tersedia secara otomatis.

---

## Pengaturan

Buka Pengaturan dari bilah menu: klik ikon Window Resize, lalu pilih **"Pengaturan..."** (pintasan: **⌘,**).

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
3. Ukuran baru muncul di daftar kustom dan langsung tersedia di menu ubah ukuran.

Untuk menghapus ukuran kustom, klik tombol **"Hapus"** berwarna merah di sebelahnya.

> Ukuran kustom muncul di menu ubah ukuran setelah ukuran bawaan.

### Jalankan Saat Login

Aktifkan **"Jalankan Saat Login"** agar Window Resize otomatis berjalan saat Anda masuk ke macOS.

### Tangkapan Layar

Aktifkan **"Ambil tangkapan layar setelah mengubah ukuran"** untuk secara otomatis menangkap jendela setelah diubah ukurannya.

Saat diaktifkan, opsi berikut tersedia:

- **Simpan ke file** — Simpan tangkapan layar sebagai file PNG. Saat diaktifkan, pilih lokasi penyimpanan:
  > **Format nama file:** `MMddHHmmss_NamaAplikasi_JudulJendela.png` (contoh: `0227193012_Safari_Apple.png`). Simbol dihapus; hanya huruf, angka, dan garis bawah yang digunakan.
  - **Desktop** — Simpan ke folder Desktop Anda.
  - **Gambar** — Simpan ke folder Gambar Anda.
- **Salin ke papan klip** — Salin tangkapan layar ke papan klip untuk ditempelkan ke aplikasi lain.

Kedua opsi dapat diaktifkan secara independen. Misalnya, Anda dapat menyalin ke papan klip tanpa menyimpan ke file.

> **Catatan:** Fitur tangkapan layar memerlukan izin **Perekaman Layar**. Saat pertama kali menggunakan fitur ini, macOS akan meminta Anda untuk memberikan izin di **Pengaturan Sistem > Privasi & Keamanan > Perekaman Layar**.

### Status Aksesibilitas

Di bagian bawah jendela Pengaturan, indikator status menunjukkan kondisi terkini izin Aksesibilitas:

| Indikator | Arti |
|-----------|------|
| 🟢 **Aksesibilitas: Aktif** | Izin aktif dan berfungsi dengan benar. |
| 🟠 **Aksesibilitas: Perlu Diperbarui** | Sistem melaporkan izin telah diberikan, tetapi tidak lagi berlaku (lihat [Memperbaiki Izin yang Kedaluwarsa](#memperbaiki-izin-yang-kedaluwarsa)). Tombol **"Buka Pengaturan"** ditampilkan. |
| 🔴 **Aksesibilitas: Tidak Aktif** | Izin belum diberikan. Tombol **"Buka Pengaturan"** ditampilkan. |

---

## Pemecahan Masalah

### Memperbaiki Izin yang Kedaluwarsa

Jika Anda melihat indikator status berwarna oranye atau pesan "Aksesibilitas: Perlu Diperbarui", izin telah kedaluwarsa. Ini dapat terjadi setelah aplikasi diperbarui atau dibangun ulang.

**Untuk memperbaiki:**

1. Buka **Pengaturan Sistem > Privasi & Keamanan > Aksesibilitas**.
2. Temukan **"Window Resize"** di daftar.
3. Matikan sakelarnya, lalu nyalakan kembali.
4. Alternatif lain, hapus sepenuhnya dari daftar, lalu luncurkan ulang aplikasi untuk menambahkannya kembali.

### Gagal Mengubah Ukuran

Jika Anda melihat peringatan "Gagal Mengubah Ukuran", kemungkinan penyebabnya meliputi:

- Aplikasi target tidak mendukung pengubahan ukuran berbasis Aksesibilitas.
- Jendela sedang dalam **mode layar penuh** (keluar dari layar penuh terlebih dahulu).
- Izin Aksesibilitas tidak aktif (periksa status di Pengaturan).

### Jendela Tidak Muncul di Daftar

Menu ubah ukuran hanya menampilkan jendela yang:

- Saat ini terlihat di layar
- Bukan bagian dari desktop (misalnya, desktop Finder dikecualikan)
- Bukan jendela milik aplikasi Window Resize itu sendiri

Jika jendela diminimalkan ke Dock, jendela tersebut tidak akan muncul di daftar.

### Tangkapan Layar Tidak Berfungsi

Jika tangkapan layar tidak tertangkap:

- Berikan izin **Perekaman Layar** di **Pengaturan Sistem > Privasi & Keamanan > Perekaman Layar**.
- Pastikan setidaknya salah satu dari **"Simpan ke file"** atau **"Salin ke papan klip"** diaktifkan.
