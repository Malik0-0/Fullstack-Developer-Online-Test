# Test Script untuk Task Management API (PowerShell Version)
# Pastikan server sudah running di http://localhost:3000
# Pastikan PostgreSQL sudah running dan database sudah diinisialisasi

$BASE_URL = "http://localhost:3000/api"
$TOKEN = "secret-token-123"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Testing Task Management API" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Function untuk menjalankan test
function Run-Test {
    param(
        [string]$TestName,
        [string]$Method,
        [string]$Endpoint,
        [hashtable]$Headers = @{},
        [string]$Body = ""
    )
    
    Write-Host "$TestName" -ForegroundColor Yellow
    Write-Host "-" * $TestName.Length -ForegroundColor Yellow
    
    try {
        $fullUrl = "$BASE_URL$Endpoint"
        $params = @{
            Method = $Method
            Uri = $fullUrl
            Headers = $Headers
        }
        
        if ($Body) {
            $params.Body = $Body
            $params.ContentType = "application/json"
        }
        
        $response = Invoke-RestMethod @params
        $statusCode = 200
        
        Write-Host "Status: $statusCode" -ForegroundColor Green
        Write-Host "Response: $($response | ConvertTo-Json -Compress)" -ForegroundColor Green
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $responseBody = $_.ErrorDetails.Message
        
        Write-Host "Status: $statusCode" -ForegroundColor Red
        Write-Host "Response: $responseBody" -ForegroundColor Red
    }
    
    Write-Host ""
    return $response
}

# Test 1: Login - Success
$response1 = Run-Test -TestName "Test 1: Login - Success" -Method "POST" -Endpoint "/login" -Body '{"email":"admin@example.com","password":"password123"}'

# Test 2: Login - Invalid Credentials
Run-Test -TestName "Test 2: Login - Invalid Credentials" -Method "POST" -Endpoint "/login" -Body '{"email":"wrong@example.com","password":"wrong"}'

# Test 3: Login - Missing Fields
Run-Test -TestName "Test 3: Login - Missing Fields" -Method "POST" -Endpoint "/login" -Body '{"email":"admin@example.com"}'

# Test 4: Get Tasks - Without Token
Run-Test -TestName "Test 4: Get Tasks - Without Token" -Method "GET" -Endpoint "/tasks"

# Test 5: Get Tasks - With Valid Token
$response5 = Run-Test -TestName "Test 5: Get Tasks - With Valid Token" -Method "GET" -Endpoint "/tasks" -Headers @{Authorization = "Bearer $TOKEN"}

# Test 6: Create Task - Success
$response6 = Run-Test -TestName "Test 6: Create Task - Success" -Method "POST" -Endpoint "/tasks" -Headers @{Authorization = "Bearer $TOKEN"} -Body '{"title":"Test Task","description":"Test Description","status":"pending"}'

# Extract Task ID dari response Test 6
$TASK_ID = $null
if ($response6 -and $response6.id) {
    $TASK_ID = $response6.id
    Write-Host "Task ID: $TASK_ID" -ForegroundColor Cyan
}

# Test 7: Create Task - Missing Title
Run-Test -TestName "Test 7: Create Task - Missing Title" -Method "POST" -Endpoint "/tasks" -Headers @{Authorization = "Bearer $TOKEN"} -Body '{"description":"Test Description"}'

# Test 8: Create Task - Invalid Status
Run-Test -TestName "Test 8: Create Task - Invalid Status" -Method "POST" -Endpoint "/tasks" -Headers @{Authorization = "Bearer $TOKEN"} -Body '{"title":"Test Task","status":"invalid"}'

# Test 9: Get Task by ID - Success (jika ada TASK_ID)
if ($TASK_ID) {
    Run-Test -TestName "Test 9: Get Task by ID - Success" -Method "GET" -Endpoint "/tasks/$TASK_ID" -Headers @{Authorization = "Bearer $TOKEN"}
}

# Test 10: Get Task by ID - Not Found
Run-Test -TestName "Test 10: Get Task by ID - Not Found" -Method "GET" -Endpoint "/tasks/99999" -Headers @{Authorization = "Bearer $TOKEN"}

# Test 11: Update Task - Success (jika ada TASK_ID)
if ($TASK_ID) {
    Run-Test -TestName "Test 11: Update Task - Success" -Method "PUT" -Endpoint "/tasks/$TASK_ID" -Headers @{Authorization = "Bearer $TOKEN"} -Body '{"title":"Updated Task","status":"done"}'
}

# Test 12: Update Task - Not Found
Run-Test -TestName "Test 12: Update Task - Not Found" -Method "PUT" -Endpoint "/tasks/99999" -Headers @{Authorization = "Bearer $TOKEN"} -Body '{"title":"Updated Task"}'

# Test 13: Update Task - No Fields (jika ada TASK_ID)
if ($TASK_ID) {
    Run-Test -TestName "Test 13: Update Task - No Fields" -Method "PUT" -Endpoint "/tasks/$TASK_ID" -Headers @{Authorization = "Bearer $TOKEN"} -Body '{}'
}

# Test 14: Delete Task - Success (jika ada TASK_ID)
if ($TASK_ID) {
    Run-Test -TestName "Test 14: Delete Task - Success" -Method "DELETE" -Endpoint "/tasks/$TASK_ID" -Headers @{Authorization = "Bearer $TOKEN"}
}

# Test 15: Delete Task - Not Found
Run-Test -TestName "Test 15: Delete Task - Not Found" -Method "DELETE" -Endpoint "/tasks/99999" -Headers @{Authorization = "Bearer $TOKEN"}

# Test 16: Pagination
Run-Test -TestName "Test 16: Pagination" -Method "GET" -Endpoint "/tasks?page=1&limit=5" -Headers @{Authorization = "Bearer $TOKEN"}

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Testing selesai!" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
