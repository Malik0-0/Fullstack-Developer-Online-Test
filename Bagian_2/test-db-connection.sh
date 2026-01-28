#!/bin/bash

echo "=========================================="
echo "Testing Database Connection"
echo "=========================================="
echo ""

echo "1. Checking .env file..."
if [ -f .env ]; then
    echo "✅ .env file exists"
    echo "Contents:"
    cat .env | grep -E "DB_|PORT" | sed 's/PASSWORD=.*/PASSWORD=***/'
else
    echo "❌ .env file not found!"
    exit 1
fi

echo ""
echo "2. Checking Docker container..."
if docker ps | grep -q task_management_postgres; then
    echo "✅ Docker container is running"
    docker ps | grep task_management_postgres
else
    echo "❌ Docker container is not running!"
    echo "Starting container..."
    docker-compose up -d
    sleep 5
fi

echo ""
echo "3. Testing connection from inside container..."
docker exec task_management_postgres psql -U postgres -d task_management -c "SELECT current_database(), current_user;" 2>&1

echo ""
echo "4. Testing connection from Node.js..."
if command -v node &> /dev/null; then
    node test-connection.js
else
    echo "⚠️  Node.js not found in PATH, skipping Node.js test"
    echo "   But you can test it manually with: npm start"
fi

echo ""
echo "=========================================="
echo "Test completed!"
echo "=========================================="
