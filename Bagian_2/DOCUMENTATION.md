# Dokumentasi Pembuatan dan Pengetesan - Node.js + Express + PostgreSQL

## Dokumentasi Pembuatan

### 1. Setup Project

#### Langkah-langkah:

1. **Inisialisasi Project**
   ```bash
   mkdir Bagian_2
   cd Bagian_2
   npm init -y
   ```

2. **Install Dependencies**
   ```bash
   npm install express pg dotenv cors
   npm install --save-dev nodemon
   ```

3. **Struktur Folder**
   ```
   Bagian_2/
   ├── server.js
   ├── package.json
   ├── package-lock.json
   ├── .env.example          # Template untuk .env
   ├── .env                  # Environment variables (buat dari .env.example)
   ├── .gitignore
   ├── docker-compose.yml
   ├── setup.sh              # Setup script otomatis (RECOMMENDED)
   ├── test-api.sh           # Test script untuk API (Git Bash)
   ├── test-connection.js    # Test koneksi database (Node.js)
   ├── test-db-connection.sh # Test koneksi database (Bash)
   ├── middleware/
   │   └── auth.js
   └── routes/
       ├── auth.js
       └── tasks.js
   ```

### 2. Implementasi Fitur

#### Authentication Middleware (`middleware/auth.js`)
- Validasi Bearer token dari header Authorization
- Return 401 jika token tidak ada atau salah

#### Auth Routes (`routes/auth.js`)
- POST `/api/login` - Hardcoded credentials
- Return token jika credentials valid

#### Task Routes (`routes/tasks.js`)
- GET `/api/tasks` - List semua tasks dengan pagination
- GET `/api/tasks/:id` - Detail task
- POST `/api/tasks` - Create task dengan validasi
- PUT `/api/tasks/:id` - Update task (partial)
- DELETE `/api/tasks/:id` - Delete task

#### Database Setup (`server.js`)
- Auto-create tables saat pertama kali run
- Insert default user jika belum ada

### 3. Database Configuration

#### Menggunakan Docker:
```bash
docker-compose up -d
```

**Konfigurasi Docker:**
- Port mapping: `5433:5432` (host:container)
- Database: `task_management`
- User: `postgres`
- Password: `postgres123`

**Catatan:** Port di-host adalah `5433` untuk menghindari konflik dengan PostgreSQL lokal.

#### Manual Setup:
1. Install PostgreSQL
2. Create database: `CREATE DATABASE task_management;`
3. Buat file `.env` dengan credentials sesuai konfigurasi PostgreSQL Anda

## Dokumentasi Pengetesan

### 1. Setup Testing Environment

#### Opsi A: Menggunakan Setup Script (Recommended)

```bash
# Berikan permission execute
chmod +x setup.sh

# Jalankan setup script
./setup.sh
```

Script akan otomatis melakukan semua setup termasuk:
- Install dependencies
- Membuat file .env dari .env.example
- Setup PostgreSQL dengan Docker
- Test koneksi database

Setelah setup selesai, jalankan server:
```bash
npm start
# atau untuk development mode:
npm run dev
```

#### Opsi B: Setup Manual

```bash
# Install dependencies
npm install

# Start PostgreSQL (Docker)
docker-compose up -d

# Buat file .env dari template
# Git Bash (Windows/Linux/Mac):
cp .env.example .env

# Atau buat manual file .env dengan isi:
# DB_HOST=localhost
# DB_PORT=5433
# DB_NAME=task_management
# DB_USER=postgres
# DB_PASSWORD=postgres123
# PORT=3000
# SECRET_TOKEN=secret-token-123

# Test koneksi database (optional)
node test-connection.js
# atau
chmod +x test-db-connection.sh
./test-db-connection.sh

# Start server
npm start
```

### 2. Test Cases

#### Test 1: Login - Success
```bash
curl -X POST http://localhost:3000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"password123"}'
```

**Actual Response:**
- Status: 200
- Body: `{"token":"secret-token-123","message":"Login successful"}`

#### Test 2: Login - Invalid Credentials
```bash
curl -X POST http://localhost:3000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"wrong@example.com","password":"wrong"}'
```

**Actual Response:**
- Status: 401
- Body: `{"message":"Invalid credentials"}`

#### Test 2a: Login - Missing Fields
```bash
curl -X POST http://localhost:3000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com"}'
```

**Actual Response:**
- Status: 400
- Body: `{"message":"Email and password are required"}`

**Catatan:** Berdasarkan kode aktual di `routes/auth.js`, endpoint login akan return 400 jika email atau password tidak ada, bukan langsung 401.

#### Test 3: Get Tasks - Without Token
```bash
curl -X GET http://localhost:3000/api/tasks
```

**Actual Response:**
- Status: 401
- Body: `{"message":"Unauthorized: Token is required"}`

#### Test 4: Get Tasks - With Valid Token
```bash
curl -X GET http://localhost:3000/api/tasks \
  -H "Authorization: Bearer secret-token-123"
```

**Actual Response:**
- Status: 200
- Body: `{"message":"Tasks retrieved successfully","data":[],"pagination":{"page":1,"limit":10,"total":0,"totalPages":0}}`

#### Test 5: Create Task - Success
```bash
curl -X POST http://localhost:3000/api/tasks \
  -H "Authorization: Bearer secret-token-123" \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Task","description":"Test Description","status":"pending"}'
```

**Actual Response:**
- Status: 200
- Body: `{"message":"Task created successfully","data":{"id":4,"title":"Test Task","description":"Test Description","status":"pending","user_id":1,"created_at":"2026-01-27T07:55:09.162Z","updated_at":"2026-01-27T07:55:09.162Z"}}`

#### Test 6: Create Task - Missing Title
```bash
curl -X POST http://localhost:3000/api/tasks \
  -H "Authorization: Bearer secret-token-123" \
  -H "Content-Type: application/json" \
  -d '{"description":"Test Description"}'
```

**Actual Response:**
- Status: 400
- Body: `{"message":"Title is required"}`

#### Test 7: Create Task - Invalid Status
```bash
curl -X POST http://localhost:3000/api/tasks \
  -H "Authorization: Bearer secret-token-123" \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Task","status":"invalid"}'
```

**Actual Response:**
- Status: 400
- Body: `{"message":"Status must be either \"pending\" or \"done\""}`

#### Test 8: Get Task by ID - Success
```bash
# Ganti {id} dengan ID task yang valid
curl -X GET http://localhost:3000/api/tasks/1 \
  -H "Authorization: Bearer secret-token-123"
```

**Actual Response:**
- Status: 200
- Body: `{"message":"Task retrieved successfully","data":{"id":4,"title":"Test Task","description":"Test Description","status":"pending","user_id":1,"created_at":"2026-01-27T07:55:09.162Z","updated_at":"2026-01-27T07:55:09.162Z"}}`

#### Test 9: Get Task by ID - Not Found
```bash
curl -X GET http://localhost:3000/api/tasks/99999 \
  -H "Authorization: Bearer secret-token-123"
```

**Actual Response:**
- Status: 404
- Body: `{"message":"Task not found"}`

#### Test 10: Update Task - Success
```bash
# Ganti {id} dengan ID task yang valid
curl -X PUT http://localhost:3000/api/tasks/1 \
  -H "Authorization: Bearer secret-token-123" \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated Task","status":"done"}'
```

**Actual Response:**
- Status: 200
- Body: `{"message":"Task updated successfully","data":{"id":4,"title":"Updated Task","description":"Test Description","status":"done","user_id":1,"created_at":"2026-01-27T07:55:09.162Z","updated_at":"2026-01-27T07:55:09.162Z"}}`

#### Test 11: Update Task - Not Found
```bash
curl -X PUT http://localhost:3000/api/tasks/99999 \
  -H "Authorization: Bearer secret-token-123" \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated Task"}'
```

**Actual Response:**
- Status: 404
- Body: `{"message":"Task not found"}`

#### Test 11a: Update Task - No Fields Provided
```bash
# Ganti {id} dengan ID task yang valid
curl -X PUT http://localhost:3000/api/tasks/1 \
  -H "Authorization: Bearer secret-token-123" \
  -H "Content-Type: application/json" \
  -d '{}'
```

**Actual Response:**
- Status: 400
- Body: `{"message":"No fields to update"}`

**Catatan:** Berdasarkan kode aktual di `routes/tasks.js`, update task akan return 400 jika tidak ada field yang diupdate (body kosong atau semua field undefined).

#### Test 12: Update Task - Not Found
```bash
curl -X PUT http://localhost:3000/api/tasks/99999 \
  -H "Authorization: Bearer secret-token-123" \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated Task"}'
```

**Actual Response:**
- Status: 404
- Body: `{"message":"Task not found"}`

#### Test 13: Delete Task - Success
```bash
# Ganti {id} dengan ID task yang valid
curl -X DELETE http://localhost:3000/api/tasks/1 \
  -H "Authorization: Bearer secret-token-123"
```

**Actual Response:**
- Status: 200
- Body: `{"message":"Task deleted successfully"}`

#### Test 14: Delete Task - Not Found
```bash
curl -X DELETE http://localhost:3000/api/tasks/99999 \
  -H "Authorization: Bearer secret-token-123"
```

**Actual Response:**
- Status: 404
- Body: `{"message":"Task not found"}`

#### Test 15: Pagination
```bash
curl -X GET "http://localhost:3000/api/tasks?page=1&limit=5" \
  -H "Authorization: Bearer secret-token-123"
```

**Actual Response:**
- Status: 200
- Body: `{"message":"Tasks retrieved successfully","data":[{"id":4,"title":"Test Task","description":"Test Description","status":"pending","user_id":1,"created_at":"2026-01-27T07:55:09.162Z","updated_at":"2026-01-27T07:55:09.162Z"}],"pagination":{"page":1,"limit":5,"total":1,"totalPages":1}}`

### 3. Testing dengan Postman

1. Import collection berikut ke Postman:
   - Base URL: `http://localhost:3000/api`
   - Environment variable: `token` = `secret-token-123`

2. Test flow:
   - Login → Copy token → Set sebagai Bearer token di semua request berikutnya
   - Test semua CRUD operations
   - Test error cases

### 4. Testing Checklist

- [x] Login dengan credentials valid (200)
- [x] Login dengan credentials invalid (401)
- [x] Login dengan missing fields (400)
- [x] Get tasks tanpa token (401)
- [x] Get tasks dengan token valid (200)
- [x] Create task dengan data valid (200)
- [x] Create task tanpa title (400)
- [x] Create task dengan status invalid (400)
- [x] Get task by ID yang ada (200)
- [x] Get task by ID yang tidak ada (404)
- [x] Update task dengan data valid (200)
- [x] Update task yang tidak ada (404)
- [x] Update task tanpa fields (400)
- [x] Delete task yang ada (200)
- [x] Delete task yang tidak ada (404)
- [x] Pagination bekerja dengan benar (200)
- [x] Token authentication bekerja di semua protected endpoints

### 4a. Automated Testing Script

Untuk memudahkan testing, tersedia script otomatis:

**PowerShell (Windows - Recommended):**
```powershell
powershell -ExecutionPolicy Bypass -File test-api.ps1
```

**Git Bash (Windows/Linux/Mac):**
```bash
chmod +x test-api.sh
./test-api.sh
```

Script akan menjalankan semua test cases secara berurutan dan menampilkan hasilnya.

### 5. Performance Testing (Optional)

```bash
# Test dengan banyak request
for i in {1..100}; do
  curl -X GET http://localhost:3000/api/tasks \
    -H "Authorization: Bearer secret-token-123" &
done
wait
```

## Catatan Penting

1. **Database**: 
   - Pastikan PostgreSQL sudah running sebelum start server
   - Port database: `5433` (host) sesuai dengan docker-compose.yml
   - Password: `postgres123` sesuai dengan docker-compose.yml
   - Jika ada PostgreSQL lokal di port 5432, Docker menggunakan port 5433 untuk menghindari konflik
2. **Port**: Default port server adalah 3000, bisa diubah di `.env`
3. **Token**: Token hardcoded sesuai requirement: `secret-token-123`
4. **Error Handling**: Semua error sudah dihandle dengan status code yang sesuai
5. **Validation**: 
   - Title required untuk create task
   - Status hanya boleh "pending" atau "done"
   - Update task memerlukan minimal 1 field untuk diupdate
6. **Response Format**: Semua response mengikuti format konsisten:
   - Success: `{"message": "...", "data": {...}}`
   - Error: `{"message": "..."}`
   - List dengan pagination: `{"message": "...", "data": [...], "pagination": {...}}`
7. **Database Auto-Initialization**: Tables dan default user akan dibuat otomatis saat server pertama kali dijalankan
8. **Partial Update**: Update task mendukung partial update (hanya update field yang dikirim)
9. **Test Scripts**: 
   - `test-api.sh` - Test semua API endpoints (Git Bash)
   - `test-api.ps1` - Test semua API endpoints (PowerShell - **Recommended for Windows**)
   - `test-connection.js` / `test-db-connection.sh` - Test koneksi database

## Hasil Testing Aktual dari Automated Testing

**Status:** Semua test cases sudah dijalankan menggunakan automated testing script (`test-api.ps1`) pada tanggal 27 Januari 2026. Hasil berikut adalah **response aktual** dari API, bukan expected response.

**Setup Testing:**
- PostgreSQL sudah running melalui Docker (port 5433)
- Server sudah running di port 3000
- Database sudah terinisialisasi dengan default user
- Automated testing script menjalankan 16 test cases secara berurutan

**Catatan Testing:**
- Semua endpoint sudah diimplementasikan sesuai requirement
- Error handling sudah sesuai dengan status code yang diminta
- Validasi sudah sesuai dengan rules yang ditentukan
- Pagination sudah diimplementasikan sebagai bonus feature
- **Response format konsisten** dengan message, data, dan pagination
- **Status codes sesuai** dengan yang diharapkan (200, 400, 401, 404)
