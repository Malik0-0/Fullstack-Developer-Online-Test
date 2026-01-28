# Fullstack Developer Online Test

Solusi untuk tes online Fullstack Developer.

Repository ini berisi dua bagian solusi:

- **[Bagian 1](./Bagian_1/)** - Algoritma Array Merge & Sort dengan PHP
- **[Bagian 2](./Bagian_2/)** - Task Management REST API dengan Node.js + Express + PostgreSQL

---

## 📋 Overview

### Bagian 1: Array Merge & Sort Algorithm

**Teknologi:** PHP

**Tugas:**
1. Merge dua array dan sort secara ascending
2. Cari integer yang hilang berdasarkan pola angka
3. Masukkan integer yang hilang ke dalam array hasil merge
4. Hasil akhir: pola angka tersusun tanpa ada integer yang hilang

**Fitur:**
- ✅ Implementasi manual merge array (tanpa fungsi bawaan PHP)
- ✅ Bubble sort untuk sorting ascending
- ✅ Deteksi dan insert missing integers
- ✅ Script bash untuk menjalankan solusi

**📖 [Lihat dokumentasi lengkap →](./Bagian_1/README.md)**

---

### Bagian 2: Task Management REST API

**Teknologi:** Node.js, Express.js, PostgreSQL

**Tugas:**
Membangun REST API untuk Task Management dengan:
- Authentication berbasis token
- CRUD operations untuk tasks
- Validasi request
- Error handling yang proper

**Fitur:**
- ✅ Authentication dengan Bearer Token
- ✅ CRUD lengkap untuk tasks (Create, Read, Update, Delete)
- ✅ Pagination untuk list tasks (bonus)
- ✅ Docker support untuk PostgreSQL
- ✅ Automated testing scripts
- ✅ Dokumentasi lengkap dengan contoh request

**📖 [Lihat dokumentasi lengkap →](./Bagian_2/README.md)**

---

## 🚀 Quick Start

### Bagian 1

```bash
cd Bagian_1
chmod +x run.sh
./run.sh
```

**Requirements:** PHP 7.0+

**📖 [Panduan lengkap →](./Bagian_1/README.md)**

---

### Bagian 2

```bash
cd Bagian_2
chmod +x setup.sh
./setup.sh
npm start
```

**Requirements:** Node.js 14+, Docker

**📖 [Panduan lengkap →](./Bagian_2/README.md)**

---

## 📁 Struktur Repository

```
.
├── README.md                 # File ini - overview kedua project
├── Bagian_1/
│   ├── README.md            # Dokumentasi Bagian 1
│   ├── solution_php.php     # Solusi PHP
│   └── run.sh               # Script untuk menjalankan
├── Bagian_2/
│   ├── README.md            # Dokumentasi utama Bagian 2
│   ├── QUICKSTART.md        # Panduan cepat
│   ├── DOCUMENTATION.md     # Dokumentasi detail
│   ├── server.js            # Main server file
│   ├── package.json         # Dependencies
│   ├── docker-compose.yml   # Docker setup PostgreSQL
│   ├── setup.sh             # Setup script otomatis
│   ├── routes/              # API routes
│   └── middleware/           # Authentication middleware
└── .gitignore               # Git ignore rules
```

---

## 🛠️ Tech Stack

### Bagian 1
- **Language:** PHP 7.0+
- **Algorithm:** Bubble Sort, Manual Array Operations

### Bagian 2
- **Runtime:** Node.js 14+
- **Framework:** Express.js
- **Database:** PostgreSQL
- **Container:** Docker & Docker Compose
- **Testing:** Automated bash/PowerShell scripts

---

## 📝 Catatan

- Setiap bagian memiliki README.md sendiri dengan dokumentasi lengkap
- Bagian 1 fokus pada algoritma dan implementasi manual
- Bagian 2 fokus pada REST API development dengan best practices
- Semua kode sudah diuji dan siap digunakan

---

**Selamat mencoba! 🎉**
