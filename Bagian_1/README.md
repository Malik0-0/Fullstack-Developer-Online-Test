# Solusi Test - Bagian 1

## Deskripsi

Solusi untuk test yang meminta:

1. Merge dua array dan sort secara ascending
2. Cari integer yang hilang berdasarkan pola angka
3. Masukkan integer yang hilang ke dalam array hasil merge
4. Hasil akhir: pola angka tersusun tanpa ada integer yang hilang

## Requirements

- **PHP** 7.0 atau lebih baru  
- **Windows:** Jalankan `php solution_php.php` langsung, atau gunakan Git Bash / WSL untuk `./run.sh`

## File Solusi

### solution_php.php

**Versi PHP** - Sesuai dengan struktur soal asli

- Menggunakan class Test dengan struktur yang sama persis dengan soal
- Tidak menggunakan fungsi bawaan PHP seperti `array_merge()`, `array_push()`, `asort()`
- Menggunakan bubble sort untuk sorting manual
- Menggunakan loop manual untuk merge array

**Cara menjalankan:**

**Opsi 1: Menggunakan script (Recommended)**

```bash
chmod +x run.sh
./run.sh
```

**Opsi 2: Langsung dengan PHP**

```bash
php solution_php.php
```

## Penjelasan Algoritma

### 1. mergeSortArray()

**Tujuan:** Menggabungkan dua array dan mengurutkannya secara ascending

**Langkah:**

1. Buat array result kosong
2. Loop melalui array pertama, tambahkan setiap elemen ke result
3. Loop melalui array kedua, tambahkan setiap elemen ke result
4. Gunakan bubble sort untuk mengurutkan result secara ascending

**Contoh:**

- Input: a = [11, 36, 65, 135, 98], b = [81, 23, 50, 155]
- Setelah merge: [11, 36, 65, 135, 98, 81, 23, 50, 155]
- Setelah sort: [11, 23, 36, 50, 65, 81, 98, 135, 155]

### 2. getMissingData()

**Tujuan:** Mencari integer yang hilang antara nilai minimum dan maksimum

**Langkah:**

1. Cari nilai minimum (elemen pertama setelah sort) dan maksimum (elemen terakhir)
2. Loop dari min+1 sampai max-1
3. Untuk setiap angka, cek apakah ada di array
4. Jika tidak ada, tambahkan ke array missing

**Contoh:**

- Input: [11, 23, 36, 50, 65, 81, 98, 135, 155]
- Min = 11, Max = 155
- Missing: [12, 13, 14, ..., 154] (semua angka antara 11 dan 155 yang tidak ada)

### 3. insertMissingData()

**Tujuan:** Memasukkan data yang hilang ke dalam array

**Langkah:**

1. Salin semua elemen dari array asli ke result
2. Tambahkan semua elemen dari missingData ke result
3. Sort lagi menggunakan bubble sort

**Contoh:**

- Input: [11, 23, 36, 50, 65, 81, 98, 135, 155] + missing data
- Output: [11, 12, 13, ..., 154, 155] (urutan lengkap tanpa ada yang hilang)

## Bubble Sort

Algoritma sorting sederhana yang bekerja dengan:

1. Membandingkan elemen berdekatan
2. Jika elemen kiri > elemen kanan, swap
3. Ulangi sampai tidak ada lagi swap yang diperlukan

## Catatan

- Kode dibuat sederhana dan mudah dijelaskan
- Tidak menggunakan fungsi bawaan untuk merge dan sort sesuai syarat soal
