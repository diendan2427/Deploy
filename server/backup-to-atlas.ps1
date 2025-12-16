# ==========================================
# MongoDB Atlas Migration Script
# ==========================================
# Script tự động backup và restore MongoDB
# Từ local sang Atlas
# ==========================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MongoDB Atlas Migration Tool" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Kiểm tra MongoDB Compass có đang chạy không
Write-Host "Step 1: Checking MongoDB connection..." -ForegroundColor Yellow

# Test connection với mongosh
$mongoInstalled = Get-Command mongosh -ErrorAction SilentlyContinue
$mongodumpInstalled = Get-Command mongodump -ErrorAction SilentlyContinue

if (-not $mongoInstalled -and -not $mongodumpInstalled) {
    Write-Host ""
    Write-Host "WARNING: MongoDB tools not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "You have 2 options:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Option 1: Use MongoDB Compass GUI (RECOMMENDED - Easiest)" -ForegroundColor Green
    Write-Host "  1. Open MongoDB Compass" -ForegroundColor White
    Write-Host "  2. Connect to: mongodb://localhost:27017" -ForegroundColor White
    Write-Host "  3. Select database: bughunter" -ForegroundColor White
    Write-Host "  4. For each collection:" -ForegroundColor White
    Write-Host "     - Click 'Export Data' button" -ForegroundColor White
    Write-Host "     - Choose format: JSON" -ForegroundColor White
    Write-Host "     - Save to: backup\ folder" -ForegroundColor White
    Write-Host ""
    Write-Host "Option 2: Install MongoDB Database Tools" -ForegroundColor Green
    Write-Host "  Download from: https://www.mongodb.com/try/download/database-tools" -ForegroundColor White
    Write-Host ""
    Write-Host "For detailed instructions, see:" -ForegroundColor Cyan
    Write-Host "  docs\MONGODB_ATLAS_MIGRATION.md" -ForegroundColor White
    Write-Host ""
    
    $continue = Read-Host "Have you already exported data manually? (Y/N)"
    if ($continue -ne "Y" -and $continue -ne "y") {
        Write-Host "Exiting... Please export data first." -ForegroundColor Red
        exit
    }
} else {
    Write-Host "MongoDB tools found!" -ForegroundColor Green
    
    # Tạo thư mục backup
    $backupDir = "backup"
    if (-not (Test-Path $backupDir)) {
        New-Item -ItemType Directory -Path $backupDir | Out-Null
        Write-Host "Created backup directory: $backupDir" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "Step 2: Backing up local database..." -ForegroundColor Yellow
    Write-Host "This may take a few minutes depending on data size..." -ForegroundColor Gray
    
    # Backup using mongodump
    $localUri = "mongodb://localhost:27017/bughunter"
    $backupPath = ".\$backupDir"
    
    try {
        mongodump --uri=$localUri --out=$backupPath
        Write-Host "Backup completed successfully!" -ForegroundColor Green
        Write-Host "Backup location: $backupPath" -ForegroundColor Cyan
    } catch {
        Write-Host "Error during backup: $_" -ForegroundColor Red
        Write-Host "Please try using MongoDB Compass GUI instead." -ForegroundColor Yellow
        exit
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Step 3: MongoDB Atlas Setup" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Now, you need to:" -ForegroundColor White
Write-Host "1. Create MongoDB Atlas account (if not already)" -ForegroundColor White
Write-Host "2. Create a FREE cluster (M0)" -ForegroundColor White
Write-Host "3. Create database user" -ForegroundColor White
Write-Host "4. Whitelist IP (0.0.0.0/0 for development)" -ForegroundColor White
Write-Host "5. Get connection string" -ForegroundColor White
Write-Host ""
Write-Host "See detailed guide: docs\MONGODB_ATLAS_MIGRATION.md" -ForegroundColor Cyan
Write-Host ""

$hasAtlas = Read-Host "Do you already have MongoDB Atlas connection string? (Y/N)"

if ($hasAtlas -ne "Y" -and $hasAtlas -ne "y") {
    Write-Host ""
    Write-Host "Please complete Atlas setup first, then run this script again." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Quick links:" -ForegroundColor Cyan
    Write-Host "  Register: https://www.mongodb.com/cloud/atlas/register" -ForegroundColor White
    Write-Host "  Guide: docs\MONGODB_ATLAS_MIGRATION.md" -ForegroundColor White
    Write-Host ""
    exit
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Step 4: Restore to Atlas" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($mongodumpInstalled) {
    Write-Host "Enter your MongoDB Atlas connection string:" -ForegroundColor Yellow
    Write-Host "(Format: mongodb+srv://username:password@cluster.xxxxx.mongodb.net/bughunter)" -ForegroundColor Gray
    $atlasUri = Read-Host "Connection string"
    
    if ([string]::IsNullOrWhiteSpace($atlasUri)) {
        Write-Host "Connection string cannot be empty!" -ForegroundColor Red
        exit
    }
    
    Write-Host ""
    Write-Host "Restoring to Atlas..." -ForegroundColor Yellow
    Write-Host "This may take several minutes..." -ForegroundColor Gray
    
    try {
        $restorePath = ".\$backupDir\bughunter"
        mongorestore --uri=$atlasUri $restorePath
        Write-Host ""
        Write-Host "Restore completed successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Error during restore: $_" -ForegroundColor Red
        Write-Host "Please try using MongoDB Compass GUI instead." -ForegroundColor Yellow
        exit
    }
} else {
    Write-Host "Use MongoDB Compass to import data:" -ForegroundColor Yellow
    Write-Host "1. Open MongoDB Compass" -ForegroundColor White
    Write-Host "2. Connect using your Atlas connection string" -ForegroundColor White
    Write-Host "3. Create database: bughunter" -ForegroundColor White
    Write-Host "4. For each JSON file in backup\:" -ForegroundColor White
    Write-Host "   - Create collection" -ForegroundColor White
    Write-Host "   - Click 'Add Data' > 'Import JSON or CSV file'" -ForegroundColor White
    Write-Host "   - Select the corresponding JSON file" -ForegroundColor White
    Write-Host ""
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Step 5: Update .env file" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$updateEnv = Read-Host "Do you want to automatically update .env file? (Y/N)"

if ($updateEnv -eq "Y" -or $updateEnv -eq "y") {
    # Backup current .env
    if (Test-Path ".env") {
        Copy-Item ".env" ".env.local.backup" -Force
        Write-Host "Backed up current .env to .env.local.backup" -ForegroundColor Green
    }
    
    Write-Host "Enter your MongoDB Atlas connection string:" -ForegroundColor Yellow
    $newMongoUri = Read-Host "Connection string"
    
    if (Test-Path ".env") {
        $envContent = Get-Content ".env" -Raw
        $envContent = $envContent -replace "MONGODB_URI=.*", "MONGODB_URI=$newMongoUri"
        Set-Content ".env" $envContent
        Write-Host ".env file updated successfully!" -ForegroundColor Green
    } else {
        Write-Host ".env file not found! Please update manually." -ForegroundColor Red
    }
} else {
    Write-Host ""
    Write-Host "Please update .env manually:" -ForegroundColor Yellow
    Write-Host "Change MONGODB_URI to your Atlas connection string" -ForegroundColor White
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Migration Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Test the connection:" -ForegroundColor White
Write-Host "   cd server" -ForegroundColor Gray
Write-Host "   npm run dev" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Verify all features work correctly" -ForegroundColor White
Write-Host ""
Write-Host "3. Share connection string with team members" -ForegroundColor White
Write-Host "   (Use secure channel, don't commit to git!)" -ForegroundColor Gray
Write-Host ""
Write-Host "For troubleshooting, see: docs\MONGODB_ATLAS_MIGRATION.md" -ForegroundColor Cyan
Write-Host ""
