# Task Management API - Node.js + Express + PostgreSQL

## Deskripsi

REST API sederhana untuk Task Management dengan fitur:
- Authentication berbasis token
- CRUD operations untuk tasks
- Validasi request
- Error handling yang proper
- Pagination (bonus)
- Docker support untuk PostgreSQL

## Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: PostgreSQL
- **Authentication**: Bearer Token

## Prerequisites

- Node.js (v14 atau lebih baru)
- Docker (untuk PostgreSQL) - Recommended
- npm atau yarn
- Git Bash (untuk menjalankan script setup)

**Catatan:** Untuk panduan cepat, lihat [QUICKSTART.md](QUICKSTART.md)

## Quick Start (Recommended)

Gunakan script setup otomatis untuk memudahkan instalasi:

```bash
# Berikan permission execute (jika perlu)
chmod +x setup.sh

# Jalankan setup script
./setup.sh
```

Script akan otomatis:
- ✅ Mengecek Node.js dan Docker
- ✅ Install dependencies
- ✅ Membuat file `.env` dari `.env.example`
- ✅ Setup PostgreSQL dengan Docker
- ✅ Test koneksi database

Setelah setup selesai, jalankan server:
```bash
npm start
# atau untuk development mode:
npm run dev
```

## Instalasi Manual

### 1. Clone atau download project ini

### 2. Install dependencies

```bash
npm install
```

### 3. Setup Database

#### Opsi A: Menggunakan Docker (Recommended)

```bash
# Start PostgreSQL container
docker-compose up -d

# Database akan otomatis dibuat dengan:
# - Database: task_management
# - User: postgres
# - Password: postgres123
# - Port: 5433 (host) -> 5432 (container)
```

**Catatan:** Port di-host adalah `5433` untuk menghindari konflik dengan PostgreSQL lokal yang mungkin berjalan di port `5432`.

#### Opsi B: Install PostgreSQL Manual

1. Install PostgreSQL di sistem Anda
2. Buat database:
```sql
CREATE DATABASE task_management;
```

### 4. Konfigurasi Environment Variables

Buat file `.env` di root project dengan isi berikut:

**Git Bash (Windows/Linux/Mac):**
```bash
cp .env.example .env
```

**Atau buat manual file `.env` dengan isi:**

```env
DB_HOST=localhost
DB_PORT=5433
DB_NAME=task_management
DB_USER=postgres
DB_PASSWORD=postgres123
PORT=3000
SECRET_TOKEN=secret-token-123
```

**Catatan Penting:**
- `DB_PORT=5433` - Port ini sesuai dengan mapping di `docker-compose.yml` (5433:5432)
- `DB_PASSWORD=postgres123` - Password sesuai dengan `POSTGRES_PASSWORD` di `docker-compose.yml`
- Jika menggunakan PostgreSQL lokal, sesuaikan port dan password sesuai konfigurasi Anda

## Menjalankan Aplikasi

### Development Mode (dengan auto-reload)

```bash
npm run dev
```

### Production Mode

```bash
npm start
```

Server akan berjalan di `http://localhost:3000`

## API Endpoints

### Base URL
```
http://localhost:3000/api
```

### 1. Login

**POST** `/api/login`

Mendapatkan token untuk authentication.

**Request Body:**
```json
{
  "email": "admin@example.com",
  "password": "password123"
}
```

**Response Success (200):**
```json
{
  "token": "secret-token-123",
  "message": "Login successful"
}
```

**Response Error (401):**
```json
{
  "message": "Invalid credentials"
}
```

**cURL:**
```bash
curl -X POST http://localhost:3000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"password123"}'
```

### 2. Get All Tasks

**GET** `/api/tasks`

Mendapatkan daftar semua tasks dengan pagination.

**Headers:**
```
Authorization: Bearer secret-token-123
```

**Query Parameters (Optional):**
- `page` - Halaman (default: 1)
- `limit` - Jumlah item per halaman (default: 10)

**Response Success (200):**
```json
{
  "message": "Tasks retrieved successfully",
  "data": [
    {
      "id": 1,
      "title": "Task 1",
      "description": "Description",
      "status": "pending",
      "user_id": 1,
      "created_at": "2026-01-27T10:00:00.000Z",
      "updated_at": "2026-01-27T10:00:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 1,
    "totalPages": 1
  }
}
```

**cURL:**
```bash
curl -X GET http://localhost:3000/api/tasks \
  -H "Authorization: Bearer secret-token-123"
```

### 3. Get Task by ID

**GET** `/api/tasks/:id`

Mendapatkan detail task berdasarkan ID.

**Headers:**
```
Authorization: Bearer secret-token-123
```

**Response Success (200):**
```json
{
  "message": "Task retrieved successfully",
  "data": {
    "id": 1,
    "title": "Task 1",
    "description": "Description",
    "status": "pending",
    "user_id": 1,
    "created_at": "2026-01-27T10:00:00.000Z",
    "updated_at": "2026-01-27T10:00:00.000Z"
  }
}
```

**Response Error (404):**
```json
{
  "message": "Task not found"
}
```

**cURL:**
```bash
curl -X GET http://localhost:3000/api/tasks/1 \
  -H "Authorization: Bearer secret-token-123"
```

### 4. Create Task

**POST** `/api/tasks`

Membuat task baru.

**Headers:**
```
Authorization: Bearer secret-token-123
Content-Type: application/json
```

**Request Body:**
```json
{
  "title": "New Task",
  "description": "Task description (optional)",
  "status": "pending"
}
```

**Validation Rules:**
- `title` - **Required**
- `status` - Optional, hanya boleh `"pending"` atau `"done"` (default: `"pending"`)

**Response Success (201):**
```json
{
  "message": "Task created successfully",
  "data": {
    "id": 1,
    "title": "New Task",
    "description": "Task description",
    "status": "pending",
    "user_id": 1,
    "created_at": "2026-01-27T10:00:00.000Z",
    "updated_at": "2026-01-27T10:00:00.000Z"
  }
}
```

**Response Error (400):**
```json
{
  "message": "Title is required"
}
```

**cURL:**
```bash
curl -X POST http://localhost:3000/api/tasks \
  -H "Authorization: Bearer secret-token-123" \
  -H "Content-Type: application/json" \
  -d '{"title":"New Task","description":"Description","status":"pending"}'
```

### 5. Update Task

**PUT** `/api/tasks/:id`

Update task (partial update diperbolehkan).

**Headers:**
```
Authorization: Bearer secret-token-123
Content-Type: application/json
```

**Request Body (semua field optional):**
```json
{
  "title": "Updated Task",
  "description": "Updated description",
  "status": "done"
}
```

**Response Success (200):**
```json
{
  "message": "Task updated successfully",
  "data": {
    "id": 1,
    "title": "Updated Task",
    "description": "Updated description",
    "status": "done",
    "user_id": 1,
    "created_at": "2026-01-27T10:00:00.000Z",
    "updated_at": "2026-01-27T10:05:00.000Z"
  }
}
```

**Response Error (404):**
```json
{
  "message": "Task not found"
}
```

**cURL:**
```bash
curl -X PUT http://localhost:3000/api/tasks/1 \
  -H "Authorization: Bearer secret-token-123" \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated Task","status":"done"}'
```

### 6. Delete Task

**DELETE** `/api/tasks/:id`

Menghapus task.

**Headers:**
```
Authorization: Bearer secret-token-123
```

**Response Success (200):**
```json
{
  "message": "Task deleted successfully"
}
```

**Response Error (404):**
```json
{
  "message": "Task not found"
}
```

**cURL:**
```bash
curl -X DELETE http://localhost:3000/api/tasks/1 \
  -H "Authorization: Bearer secret-token-123"
```

## Error Handling

| Status Code | Kondisi |
|------------|---------|
| 200 | Success GET/PUT/DELETE |
| 201 | Success POST (create task) |
| 400 | Validasi gagal |
| 401 | Token tidak ada/salah |
| 404 | Data tidak ditemukan |
| 500 | Internal server error |

## Testing

### Automated Testing Script

Tersedia script otomatis untuk testing semua endpoint:

**PowerShell (Windows - Recommended):**
```powershell
powershell -ExecutionPolicy Bypass -File test-api.ps1
```

**Git Bash (Windows/Linux/Mac):**
```bash
chmod +x test-api.sh
./test-api.sh
```

Script akan menjalankan 16 test cases termasuk:
- Login (success, invalid credentials, missing fields)
- Get tasks (with/without token)
- Create task (success, validation errors)
- Get task by ID (success, not found)
- Update task (success, not found, no fields)
- Delete task (success, not found)
- Pagination

**Catatan:** Pastikan server sudah running (`npm start`) sebelum menjalankan test script.

### Testing Database Connection

Untuk test koneksi database sebelum menjalankan server:

**Bash (Git Bash):**
```bash
chmod +x test-db-connection.sh
./test-db-connection.sh
```

**Node.js:**
```bash
node test-connection.js
```

Script ini akan mengecek:
- File `.env` ada dan konfigurasinya benar
- Docker container running
- Koneksi database berhasil

### Testing dengan Postman

1. Import collection berikut ke Postman:

**Collection JSON:**
```json
{
  "info": {
    "name": "Task Management API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Login",
      "request": {
        "method": "POST",
        "header": [{"key": "Content-Type", "value": "application/json"}],
        "body": {
          "mode": "raw",
          "raw": "{\"email\":\"admin@example.com\",\"password\":\"password123\"}"
        },
        "url": {
          "raw": "http://localhost:3000/api/login",
          "host": ["localhost"],
          "port": "3000",
          "path": ["api", "login"]
        }
      }
    },
    {
      "name": "Get All Tasks",
      "request": {
        "method": "GET",
        "header": [{"key": "Authorization", "value": "Bearer secret-token-123"}],
        "url": {
          "raw": "http://localhost:3000/api/tasks",
          "host": ["localhost"],
          "port": "3000",
          "path": ["api", "tasks"]
        }
      }
    }
  ]
}
```

2. Setelah login, copy token dan gunakan di header Authorization untuk request lainnya.

3. Untuk dokumentasi lengkap tentang testing, lihat file `DOCUMENTATION.md`

## Testing dengan Hoppscotch

1. Buka https://hoppscotch.io/
2. Gunakan endpoint dan contoh request di atas
3. Pastikan menambahkan header `Authorization: Bearer secret-token-123` untuk semua request kecuali login

## Struktur Project

```
Bagian_2/
├── server.js                  # Main server file
├── package.json               # Dependencies
├── package-lock.json          # Lock file untuk dependencies
├── .env.example              # Environment variables template (copy menjadi .env)
├── .env                       # Environment variables (tidak di-commit, buat dari .env.example)
├── .gitignore                # Git ignore rules
├── docker-compose.yml        # Docker setup untuk PostgreSQL
├── setup.sh                  # Setup script otomatis (Git Bash) - RECOMMENDED
├── test-api.sh               # Automated API test script (Git Bash)
├── test-api.ps1              # Automated API test script (PowerShell - Windows)
├── test-connection.js        # Database connection test script (Node.js)
├── test-db-connection.sh     # Database connection test script (Bash)
├── middleware/
│   └── auth.js               # Authentication middleware
├── routes/
│   ├── auth.js               # Login routes
│   └── tasks.js              # Task CRUD routes
├── README.md                 # Dokumentasi utama (file ini)
├── QUICKSTART.md             # Panduan cepat untuk setup dan menjalankan
└── DOCUMENTATION.md          # Dokumentasi pembuatan & testing detail
```

## Fitur Bonus yang Diimplementasikan

- ✅ **Pagination** - GET /tasks mendukung query params `page` dan `limit`
- ✅ **Docker** - Docker Compose untuk PostgreSQL
- ✅ **Error Handling** - Proper error handling dengan status code yang sesuai
- ✅ **Request Logging** - Console logging untuk debugging

## Catatan

- Database tables akan otomatis dibuat saat server pertama kali dijalankan
- Default user (`admin@example.com`) akan otomatis dibuat jika belum ada
- Token authentication menggunakan hardcoded token sesuai requirement
- Semua endpoint kecuali `/api/login` memerlukan token authentication
- Response format konsisten: `{"message": "...", "data": {...}}` untuk success, `{"message": "..."}` untuk error
- Update task mendukung partial update (hanya update field yang dikirim)
- Jika update task tanpa mengirim field apapun, akan return 400 dengan message "No fields to update"

## Troubleshooting

### Database connection error
- Pastikan PostgreSQL sudah running
- Cek konfigurasi di file `.env` (pastikan port `5433` dan password `postgres123`)
- Jika menggunakan Docker, pastikan container sudah running: `docker-compose ps`
- Test koneksi database: `node test-connection.js` atau `./test-db-connection.sh`
- Jika ada PostgreSQL lokal di port 5432, pastikan menggunakan port 5433 di `.env` (sesuai docker-compose.yml)

### Port already in use
- Ubah PORT di file `.env` atau
- Stop aplikasi lain yang menggunakan port 3000

### Module not found
- Jalankan `npm install` untuk install dependencies
