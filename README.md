# Fullstack Developer Online Test

Solusi untuk tes online Fullstack Developer dari Kampung Inggris Bandung.

Repository ini berisi dua bagian solusi:

- **[Bagian 1](./Bagian_1/)** - Algoritma Array Merge & Sort dengan PHP
- **[Bagian 2](./Bagian_2/)** - Task Management REST API dengan Node.js + Express + PostgreSQL

---

## 📥 Clone Repository

```bash
git clone https://github.com/Malik0-0/Fullstack-Developer-Online-Test.git
cd Fullstack-Developer-Online-Test
```

---

## 📋 Prerequisites

### Untuk Bagian 1:
- **PHP** 7.0 atau lebih baru
- **Git Bash** atau **WSL** (untuk Windows, jika ingin menjalankan `run.sh`)

### Untuk Bagian 2:
- **Node.js** 14 atau lebih baru
- **npm** (biasanya sudah termasuk dengan Node.js)
- **Docker** & **Docker Compose** (untuk PostgreSQL)
- **Git Bash** atau terminal yang mendukung bash scripts (untuk Windows)

**Cek versi yang terinstall:**
```bash
# Cek PHP
php --version

# Cek Node.js dan npm
node --version
npm --version

# Cek Docker
docker --version
docker-compose --version
```

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

### Bagian 1: Array Merge & Sort Algorithm

**Langkah-langkah:**

1. **Masuk ke folder Bagian_1**
   ```bash
   cd Bagian_1
   ```

2. **Jalankan solusi**

   **Opsi A: Menggunakan script (Recommended - Git Bash/WSL)**
   ```bash
   chmod +x run.sh
   ./run.sh
   ```

   **Opsi B: Langsung dengan PHP (Windows/Linux/Mac)**
   ```bash
   php solution_php.php
   ```

3. **Output yang diharapkan:**
   - Array a dan b ditampilkan
   - Hasil merge dan sort
   - Missing data yang ditemukan
   - Hasil akhir dengan semua integer lengkap

**📖 [Panduan lengkap →](./Bagian_1/README.md)**

---

### Bagian 2: Task Management REST API

**Langkah-langkah:**

1. **Masuk ke folder Bagian_2**
   ```bash
   cd Bagian_2
   ```

2. **Setup otomatis (Recommended)**
   ```bash
   # Berikan permission execute (jika perlu)
   chmod +x setup.sh
   
   # Jalankan setup script
   ./setup.sh
   ```
   
   Script akan otomatis:
   - ✅ Mengecek Node.js dan Docker
   - ✅ Install dependencies (`npm install`)
   - ✅ Membuat file `.env` dari `.env.example`
   - ✅ Setup PostgreSQL dengan Docker (`docker-compose up -d`)
   - ✅ Test koneksi database

3. **Start server**
   ```bash
   # Production mode
   npm start
   
   # Atau development mode (dengan auto-reload)
   npm run dev
   ```
   
   Server akan berjalan di `http://localhost:3000`

4. **Test API**
   
   **Menggunakan script otomatis:**
   ```bash
   # PowerShell (Windows)
   powershell -ExecutionPolicy Bypass -File test-api.ps1
   
   # Git Bash (Windows/Linux/Mac)
   chmod +x test-api.sh
   ./test-api.sh
   ```
   
   **Atau manual dengan curl:**
   ```bash
   # Login
   curl -X POST http://localhost:3000/api/login \
     -H "Content-Type: application/json" \
     -d '{"email":"admin@example.com","password":"password123"}'
   
   # Get tasks (gunakan token dari login)
   curl -X GET http://localhost:3000/api/tasks \
     -H "Authorization: Bearer secret-token-123"
   ```

**📖 [Panduan lengkap →](./Bagian_2/README.md)**  
**📖 [Quick Start Guide →](./Bagian_2/QUICKSTART.md)**

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

## 🔧 Troubleshooting

### Bagian 1

**Problem: `chmod: command not found` (Windows)**
- **Solusi:** Gunakan Git Bash atau WSL, atau jalankan langsung: `php solution_php.php`

**Problem: `PHP tidak ditemukan`**
- **Solusi:** Install PHP dari [php.net](https://www.php.net/downloads.php) atau gunakan XAMPP/WAMP

### Bagian 2

**Problem: `Database connection error`**
- **Solusi:** 
  - Pastikan Docker sudah running: `docker-compose ps`
  - Cek konfigurasi di `.env` (port `5433`, password `postgres123`)
  - Test koneksi: `node test-connection.js`

**Problem: `Port 3000 already in use`**
- **Solusi:** Ubah `PORT` di file `.env` atau stop aplikasi lain yang menggunakan port 3000

**Problem: `npm install` gagal**
- **Solusi:** 
  ```bash
  rm -rf node_modules package-lock.json
  npm install
  ```

**Problem: Script tidak bisa dijalankan (Windows)**
- **Solusi:** Gunakan Git Bash atau PowerShell dengan command lengkap:
  ```powershell
  powershell -ExecutionPolicy Bypass -File setup.sh
  ```

---

## 📝 Catatan

- Setiap bagian memiliki README.md sendiri dengan dokumentasi lengkap
- Bagian 1 fokus pada algoritma dan implementasi manual
- Bagian 2 fokus pada REST API development dengan best practices
- Semua kode sudah diuji dan siap digunakan
- Untuk dokumentasi detail, lihat README.md di masing-masing folder

---

## 📄 License

Repository ini dibuat sebagai solusi untuk tes online Fullstack Developer.

---

## 👤 Author

Dibuat sebagai bagian dari proses seleksi Fullstack Developer di Kampung Inggris Bandung.

---

**Selamat mencoba! 🎉**
