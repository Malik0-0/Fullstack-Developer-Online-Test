#!/bin/bash

# Test Script untuk Task Management API
# Pastikan server sudah running di http://localhost:3000
# Pastikan PostgreSQL sudah running dan database sudah diinisialisasi

BASE_URL="http://localhost:3000/api"
TOKEN="secret-token-123"

echo "=========================================="
echo "Testing Task Management API"
echo "=========================================="
echo ""

# Test 1: Login - Success
echo "Test 1: Login - Success"
echo "-----------------------"
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"password123"}')
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')
echo "Status: $HTTP_CODE"
echo "Response: $BODY"
echo ""

# Test 2: Login - Invalid Credentials
echo "Test 2: Login - Invalid Credentials"
echo "-----------------------------------"
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"wrong@example.com","password":"wrong"}')
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')
echo "Status: $HTTP_CODE"
echo "Response: $BODY"
echo ""

# Test 3: Login - Missing Fields
echo "Test 3: Login - Missing Fields"
echo "------------------------------"
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com"}')
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')
echo "Status: $HTTP_CODE"
echo "Response: $BODY"
echo ""

# Test 4: Get Tasks - Without Token
echo "Test 4: Get Tasks - Without Token"
echo "---------------------------------"
RESPONSE=$(curl -s -w "\n%{http_code}" -X GET "$BASE_URL/tasks")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')
echo "Status: $HTTP_CODE"
echo "Response: $BODY"
echo ""

# Test 5: Get Tasks - With Valid Token
echo "Test 5: Get Tasks - With Valid Token"
echo "-------------------------------------"
RESPONSE=$(curl -s -w "\n%{http_code}" -X GET "$BASE_URL/tasks" \
  -H "Authorization: Bearer $TOKEN")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')
echo "Status: $HTTP_CODE"
echo "Response: $BODY"
echo ""

# Test 6: Create Task - Success
echo "Test 6: Create Task - Success"
echo "-----------------------------"
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/tasks" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Task","description":"Test Description","status":"pending"}')
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')
TASK_ID=$(echo "$BODY" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
echo "Status: $HTTP_CODE"
echo "Response: $BODY"
echo "Task ID: $TASK_ID"
echo ""

# Test 7: Create Task - Missing Title
echo "Test 7: Create Task - Missing Title"
echo "------------------------------------"
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/tasks" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"description":"Test Description"}')
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')
echo "Status: $HTTP_CODE"
echo "Response: $BODY"
echo ""

# Test 8: Create Task - Invalid Status
echo "Test 8: Create Task - Invalid Status"
echo "-------------------------------------"
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/tasks" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Task","status":"invalid"}')
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')
echo "Status: $HTTP_CODE"
echo "Response: $BODY"
echo ""

# Test 9: Get Task by ID - Success (gunakan ID dari Test 6)
if [ ! -z "$TASK_ID" ]; then
  echo "Test 9: Get Task by ID - Success"
  echo "---------------------------------"
  RESPONSE=$(curl -s -w "\n%{http_code}" -X GET "$BASE_URL/tasks/$TASK_ID" \
    -H "Authorization: Bearer $TOKEN")
  HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
  BODY=$(echo "$RESPONSE" | sed '$d')
  echo "Status: $HTTP_CODE"
  echo "Response: $BODY"
  echo ""
fi

# Test 10: Get Task by ID - Not Found
echo "Test 10: Get Task by ID - Not Found"
echo "------------------------------------"
RESPONSE=$(curl -s -w "\n%{http_code}" -X GET "$BASE_URL/tasks/99999" \
  -H "Authorization: Bearer $TOKEN")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')
echo "Status: $HTTP_CODE"
echo "Response: $BODY"
echo ""

# Test 11: Update Task - Success
if [ ! -z "$TASK_ID" ]; then
  echo "Test 11: Update Task - Success"
  echo "-----------------------------"
  RESPONSE=$(curl -s -w "\n%{http_code}" -X PUT "$BASE_URL/tasks/$TASK_ID" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d '{"title":"Updated Task","status":"done"}')
  HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
  BODY=$(echo "$RESPONSE" | sed '$d')
  echo "Status: $HTTP_CODE"
  echo "Response: $BODY"
  echo ""
fi

# Test 12: Update Task - Not Found
echo "Test 12: Update Task - Not Found"
echo "---------------------------------"
RESPONSE=$(curl -s -w "\n%{http_code}" -X PUT "$BASE_URL/tasks/99999" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated Task"}')
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')
echo "Status: $HTTP_CODE"
echo "Response: $BODY"
echo ""

# Test 13: Update Task - No Fields
if [ ! -z "$TASK_ID" ]; then
  echo "Test 13: Update Task - No Fields"
  echo "-------------------------------"
  RESPONSE=$(curl -s -w "\n%{http_code}" -X PUT "$BASE_URL/tasks/$TASK_ID" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d '{}')
  HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
  BODY=$(echo "$RESPONSE" | sed '$d')
  echo "Status: $HTTP_CODE"
  echo "Response: $BODY"
  echo ""
fi

# Test 14: Delete Task - Success
if [ ! -z "$TASK_ID" ]; then
  echo "Test 14: Delete Task - Success"
  echo "------------------------------"
  RESPONSE=$(curl -s -w "\n%{http_code}" -X DELETE "$BASE_URL/tasks/$TASK_ID" \
    -H "Authorization: Bearer $TOKEN")
  HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
  BODY=$(echo "$RESPONSE" | sed '$d')
  echo "Status: $HTTP_CODE"
  echo "Response: $BODY"
  echo ""
fi

# Test 15: Delete Task - Not Found
echo "Test 15: Delete Task - Not Found"
echo "---------------------------------"
RESPONSE=$(curl -s -w "\n%{http_code}" -X DELETE "$BASE_URL/tasks/99999" \
  -H "Authorization: Bearer $TOKEN")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')
echo "Status: $HTTP_CODE"
echo "Response: $BODY"
echo ""

# Test 16: Pagination
echo "Test 16: Pagination"
echo "-------------------"
RESPONSE=$(curl -s -w "\n%{http_code}" -X GET "$BASE_URL/tasks?page=1&limit=5" \
  -H "Authorization: Bearer $TOKEN")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')
echo "Status: $HTTP_CODE"
echo "Response: $BODY"
echo ""

echo "=========================================="
echo "Testing selesai!"
echo "=========================================="
