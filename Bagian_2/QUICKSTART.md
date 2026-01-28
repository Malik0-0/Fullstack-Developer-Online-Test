# Quick Start Guide

Panduan cepat untuk menjalankan Task Management API.

## Prerequisites

- Node.js (v14 atau lebih baru)
- Docker (untuk PostgreSQL)
- Git Bash (untuk menjalankan script)

## Langkah Cepat

### 1. Setup Otomatis (Recommended)

```bash
# Berikan permission execute
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

### 2. Start Server

Setelah setup selesai:

```bash
# Production mode
npm start

# Development mode (dengan auto-reload)
npm run dev
```

Server akan berjalan di `http://localhost:3000`

### 3. Test API

**Menggunakan script otomatis:**

**PowerShell (Windows - Recommended):**
```powershell
powershell -ExecutionPolicy Bypass -File test-api.ps1
```

**Git Bash (Windows/Linux/Mac):**
```bash
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

## Konfigurasi

File `.env` akan dibuat otomatis dari `.env.example` dengan konfigurasi:
- Database Port: `5433` (host) → `5432` (container)
- Database Password: `postgres123`
- Server Port: `3000`
- Token: `secret-token-123`

## Troubleshooting

### Database connection error
```bash
# Cek Docker container
docker-compose ps

# Test koneksi database
node test-connection.js
```

### Port sudah digunakan
- Ubah `PORT` di file `.env`
- Atau stop aplikasi lain yang menggunakan port 3000

### Dependencies error
```bash
# Hapus node_modules dan install ulang
rm -rf node_modules package-lock.json
npm install
```

## Dokumentasi Lengkap

- **README.md** - Dokumentasi utama
- **DOCUMENTATION.md** - Dokumentasi pembuatan & testing detail
