# Window Resize — Panduan Pengguna

## Daftar Isi

1. [Pengaturan Awal](#pengaturan-awal)
2. [Snap Resize](#snap-resize)
3. [Pintasan Keyboard](#pintasan-keyboard)
4. [Pengaturan](#pengaturan)
5. [Pemecahan Masalah](#pemecahan-masalah)

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

### Move Snap

Seret jendela ke arah tepi atau sudut layar untuk menempatkannya secara otomatis:

- **Snap tepi** (kiri/kanan) — mengisi tinggi, mempertahankan lebar
- **Snap tepi** (atas/bawah) — mengisi lebar, mempertahankan tinggi
- **Snap sudut** — menempatkan jendela di sudut, mempertahankan kedua dimensi

### Tampilan Rasio Aspek

Selama mengubah ukuran, rasio aspek saat ini ditampilkan di overlay. Jika rasio tersebut sesuai dengan proporsi yang dikenal, namanya akan ditampilkan:

- **Rasio Emas** (1.618:1)
- **Rasio Perak** (2.414:1)
- **Rasio Platinum** (1.325:1)
- **Rasio Perunggu** (3.303:1)

Rasio lainnya ditampilkan sebagai pecahan sederhana (misalnya, "16:9", "4:3").

> Fitur ini dapat dinonaktifkan di Pengaturan (lihat [Tab Tampilan](#tab-tampilan)).

### Shift untuk Mengunci Rasio Aspek

Tahan tombol **Shift** saat mengubah ukuran untuk mengunci rasio aspek. Jendela akan mempertahankan proporsinya saat Anda menarik.

> Fitur ini dapat dinonaktifkan di Pengaturan (lihat [Tab Tampilan](#tab-tampilan)).

---

## Pintasan Keyboard

Semua pintasan keyboard dapat disesuaikan sepenuhnya di tab Pintasan pada Pengaturan. Default:

### Preset Cepat

Tekan **Control+Option+1** hingga **Control+Option+9** untuk langsung mengubah ukuran jendela terdepan ke preset bernama. HUD terpusat muncul sebentar menampilkan nama dan ukuran preset.

| Pintasan | Preset Default |
|----------|---------------|
| Control+Option+1 | Writing (1280 x 800) |
| Control+Option+2 | Reading (900 x 1200) |
| Control+Option+3 | Browsing (1440 x 900) |
| Control+Option+4 | Sidebar (720 x 900) |
| Control+Option+5 | Preview (1920 x 1080) |

Preset Cepat dapat diedit (label, ukuran, dan pintasan) di tab Umum pada Pengaturan. Didukung hingga 9 preset.

### Pengubahan Ukuran Bertahap

Ubah ukuran jendela terdepan sebesar 10 piksel per tekanan tombol, menjaga jendela tetap terpusat:

| Pintasan | Aksi |
|----------|------|
| Control+Option+Right | Perbesar lebar (+10px) |
| Control+Option+Left | Perkecil lebar (-10px) |
| Control+Option+Up | Perbesar tinggi (+10px) |
| Control+Option+Down | Perkecil tinggi (-10px) |

### Mode Presisi

Tahan Shift untuk penyesuaian 1 piksel:

| Pintasan | Aksi |
|----------|------|
| Control+Option+Shift+Right | Perbesar lebar (+1px) |
| Control+Option+Shift+Left | Perkecil lebar (-1px) |
| Control+Option+Shift+Up | Perbesar tinggi (+1px) |
| Control+Option+Shift+Down | Perkecil tinggi (-1px) |

### Undo / Redo

| Pintasan | Aksi |
|----------|------|
| Control+Option+Z | Batalkan pengubahan ukuran terakhir |
| Control+Option+Shift+Z | Ulangi |

Setiap jendela memiliki riwayat undo/redo sendiri.

### Umpan Balik HUD

Saat Anda menggunakan pintasan keyboard, pil HUD terpusat muncul pada jendela target:

- **Preset Cepat:** menampilkan nama preset (misalnya "Writing") dengan ukuran di bawahnya (misalnya "1280 x 800")
- **Pengubahan ukuran bertahap:** menampilkan ukuran saat ini (misalnya "1290 x 800")
- **Undo:** menampilkan "Restored" dengan ukuran yang dipulihkan

HUD ditampilkan selama 0,8 detik, lalu memudar.

---

## Pengaturan

Buka Pengaturan dari bilah menu: klik ikon Window Resize, lalu pilih **"Pengaturan..."**.

Pengaturan diorganisir dalam 4 tab: **Umum**, **Tampilan**, **Pintasan**, dan **Preset**.

### Tab Umum

#### Preset Cepat

Konfigurasikan hingga 9 Preset Cepat yang dapat diterapkan melalui pintasan keyboard (Control+Option+1-9). Setiap preset memiliki:

- **Pintasan** — klik bidang pintasan untuk merekam kombinasi tombol baru
- **Label** — nama deskriptif (misalnya "Writing", "Coding")
- **Ukuran** — lebar dan tinggi dalam piksel

Untuk menambahkan preset, isi bidang label, lebar, dan tinggi di bawah lalu klik **"Tambah"**. Untuk menghapus preset, klik tombol X di sebelahnya.

#### Jalankan Saat Login

Aktifkan **"Jalankan Saat Login"** agar Window Resize otomatis berjalan saat Anda masuk ke macOS.

#### Bahasa

Pilih bahasa tampilan aplikasi dari dropdown. Tersedia 16 bahasa atau **"Bawaan Sistem"** untuk mengikuti bahasa sistem macOS. Perubahan bahasa memerlukan peluncuran ulang aplikasi.

#### Status Aksesibilitas

Indikator status menunjukkan kondisi terkini izin Aksesibilitas:

| Indikator | Arti |
|-----------|------|
| Hijau | Izin aktif dan berfungsi dengan benar. |
| Oranye | Izin telah diberikan tetapi tidak lagi berlaku (lihat [Memperbaiki Izin yang Kedaluwarsa](#memperbaiki-izin-yang-kedaluwarsa)). |
| Merah | Izin belum diberikan. |

### Tab Tampilan

Atur gaya visual overlay snap:

- **Batas resize** — warna dan gaya garis batas yang ditampilkan saat mengubah ukuran. Pilih dari 9 warna (merah, oranye, kuning, hijau, sian, biru, ungu, putih, abu-abu) dan 4 gaya (tidak ada, solid, putus-putus, animasi). Default: putih, animasi.
- **Batas snap** — batas yang ditampilkan saat jendela di-snap ke preset. Default: putih, solid.
- **Tampilkan rasio aspek** — aktifkan/nonaktifkan label rasio aspek di overlay. Default: aktif.
- **Shift untuk mengunci rasio** — aktifkan/nonaktifkan penguncian rasio aspek saat menahan Shift. Default: aktif.

### Tab Pintasan

Semua pintasan keyboard ditampilkan dalam grid 2 kolom dan dapat disesuaikan secara individual:

1. Klik bidang pintasan di sebelah aksi mana pun.
2. Tekan kombinasi tombol yang diinginkan (harus menyertakan setidaknya satu tombol modifier).
3. Tekan **Escape** untuk membatalkan perekaman.

Jika Anda merekam pintasan yang berkonflik dengan aksi lain di aplikasi, dialog peringatan muncul menawarkan **Ganti** (tetapkan ulang pintasan) atau **Batal**.

Ikon peringatan muncul di sebelah pintasan yang berkonflik dengan pintasan sistem yang dikenal (Mission Control, Spotlight, dll.).

Klik **"Reset ke Default"** untuk mengembalikan semua pintasan ke pengikatan aslinya.

### Tab Preset

Tab Preset menampilkan 18 ukuran preset bawaan yang diurutkan berdasarkan luas piksel (terkecil ke terbesar). Setiap preset memiliki sakelar aktif/nonaktif:

- **Aktif** — preset digunakan untuk deteksi snap saat mengubah ukuran
- **Nonaktif** — preset dikecualikan dari deteksi snap (ditampilkan dengan opasitas 50%)

Preset bawaan tidak dapat dihapus, hanya dinonaktifkan. Secara default, 6 preset khusus Mac (ukuran layar MacBook Air/Pro) dinonaktifkan, dan 12 preset umum diaktifkan.

Header menunjukkan berapa banyak preset yang saat ini aktif (misalnya "12 of 18 enabled").

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
- Periksa tab Preset — ukuran target mungkin dinonaktifkan.

### Masalah Tampilan Jendela Setelah Snap

Dalam kasus yang jarang terjadi, jendela target mungkin tidak digambar ulang dengan benar setelah snap. Aplikasi secara otomatis memaksa penggambaran ulang, tetapi jika artefak visual tetap ada, coba minimalkan dan pulihkan jendela tersebut.
