#!/bin/bash

# Setup Script untuk Task Management API
# Script ini akan membantu setup project dari awal

echo "=========================================="
echo "Task Management API - Setup Script"
echo "=========================================="
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js tidak ditemukan!"
    echo "   Silakan install Node.js terlebih dahulu: https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js ditemukan: $(node --version)"
echo "✅ npm ditemukan: $(npm --version)"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "⚠️  Docker tidak ditemukan!"
    echo "   Docker diperlukan untuk menjalankan PostgreSQL"
    echo "   Install Docker: https://www.docker.com/get-started"
    echo ""
    read -p "Lanjutkan tanpa Docker? (y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
    USE_DOCKER=false
else
    echo "✅ Docker ditemukan: $(docker --version)"
    USE_DOCKER=true
fi

echo ""

# Step 1: Install dependencies
echo "Step 1: Installing dependencies..."
if [ ! -d "node_modules" ]; then
    npm install
    if [ $? -ne 0 ]; then
        echo "❌ Gagal install dependencies!"
        exit 1
    fi
    echo "✅ Dependencies berhasil diinstall"
else
    echo "✅ Dependencies sudah terinstall"
fi
echo ""

# Step 2: Setup .env file
echo "Step 2: Setting up environment variables..."
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo "✅ File .env dibuat dari .env.example"
    else
        echo "⚠️  File .env.example tidak ditemukan, membuat .env manual..."
        cat > .env << 'ENVEOF'
DB_HOST=localhost
DB_PORT=5433
DB_NAME=task_management
DB_USER=postgres
DB_PASSWORD=postgres123
PORT=3000
SECRET_TOKEN=secret-token-123
ENVEOF
        echo "✅ File .env dibuat"
    fi
else
    echo "✅ File .env sudah ada"
fi
echo ""

# Step 3: Setup Docker (if available)
if [ "$USE_DOCKER" = true ]; then
    echo "Step 3: Setting up PostgreSQL with Docker..."
    
    # Check if container is already running
    if docker ps | grep -q task_management_postgres; then
        echo "✅ PostgreSQL container sudah running"
    else
        echo "Starting PostgreSQL container..."
        docker-compose up -d
        
        if [ $? -ne 0 ]; then
            echo "❌ Gagal start Docker container!"
            exit 1
        fi
        
        echo "⏳ Menunggu PostgreSQL siap..."
        sleep 5
        
        # Wait for PostgreSQL to be ready
        for i in {1..30}; do
            if docker exec task_management_postgres pg_isready -U postgres &> /dev/null; then
                echo "✅ PostgreSQL siap!"
                break
            fi
            echo "   Menunggu... ($i/30)"
            sleep 1
        done
    fi
    echo ""
else
    echo "Step 3: Skipping Docker setup"
    echo "⚠️  Pastikan PostgreSQL sudah running dan database 'task_management' sudah dibuat"
    echo ""
fi

# Step 4: Test database connection
echo "Step 4: Testing database connection..."
if [ -f "test-connection.js" ]; then
    node test-connection.js
    if [ $? -eq 0 ]; then
        echo "✅ Database connection berhasil!"
    else
        echo "⚠️  Database connection gagal, tapi setup tetap dilanjutkan"
        echo "   Pastikan database sudah running dan konfigurasi di .env benar"
    fi
else
    echo "⚠️  test-connection.js tidak ditemukan, skip test connection"
fi
echo ""

echo "=========================================="
echo "✅ Setup selesai!"
echo "=========================================="
echo ""
echo "Selanjutnya:"
echo "1. Start server dengan: npm start"
echo "   atau untuk development: npm run dev"
echo ""
echo "2. Test API dengan: ./test-api.sh"
echo ""
echo "3. Dokumentasi lengkap ada di README.md dan DOCUMENTATION.md"
echo ""
