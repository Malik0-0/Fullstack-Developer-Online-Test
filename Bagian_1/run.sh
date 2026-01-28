#!/bin/bash

# Script untuk menjalankan solusi Bagian 1
# Pastikan PHP sudah terinstall

echo "=========================================="
echo "Running Bagian 1 Solution"
echo "=========================================="
echo ""

# Check if PHP is installed
if ! command -v php &> /dev/null; then
    echo "❌ PHP tidak ditemukan!"
    echo "   Silakan install PHP terlebih dahulu"
    echo "   Download: https://www.php.net/downloads.php"
    exit 1
fi

echo "✅ PHP ditemukan: $(php --version | head -n1)"
echo ""

# Run the solution
echo "Menjalankan solution_php.php..."
echo ""
php solution_php.php

echo ""
echo "=========================================="
echo "Selesai!"
echo "=========================================="
