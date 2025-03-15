#!/bin/bash

echo "🚀 Auto-fix script running..."

# Define base directory
BASE_DIR="/workspaces/Finalbuild"

# Ensure required directories exist
echo "📂 Ensuring all required directories exist..."
mkdir -p "$BASE_DIR/combined_files"
mkdir -p "$BASE_DIR/logs"
mkdir -p "$BASE_DIR/master_script"
mkdir -p "$BASE_DIR/structured_codebase/ai_processing"
mkdir -p "$BASE_DIR/structured_codebase/blockchain_security"
mkdir -p "$BASE_DIR/structured_codebase/core_infra"
mkdir -p "$BASE_DIR/structured_codebase/edge_computing"
mkdir -p "$BASE_DIR/structured_codebase/monitoring"
mkdir -p "$BASE_DIR/structured_codebase/mycelium"
mkdir -p "$BASE_DIR/structured_codebase/rainbow_shield"
mkdir -p "$BASE_DIR/structured_codebase/ui_api"

# Find all .sh scripts and move them to combined_files
echo "🔍 Finding and moving all scripts..."
find "$BASE_DIR" -type f -name "*.sh" ! -path "$BASE_DIR/combined_files/*" -exec mv {} "$BASE_DIR/combined_files/" \;

# Verify moved scripts
echo "📄 Verifying scripts..."
ls -lah "$BASE_DIR/combined_files/"

# Make scripts executable
echo "🔑 Making all scripts executable..."
chmod +x "$BASE_DIR/combined_files/"*.sh

# Locate one_script.sh
if [ -f "$BASE_DIR/master_script/one_script.sh" ]; then
    echo "🚀 Running Master Script..."
    cd "$BASE_DIR/master_script"
    ./one_script.sh
else
    echo "⚠ ERROR: one_script.sh not found in $BASE_DIR/master_script/"
    echo "🔍 Searching for one_script.sh..."
    FOUND_SCRIPT=$(find "$BASE_DIR" -type f -name "one_script.sh" | head -n 1)
    
    if [ -n "$FOUND_SCRIPT" ]; then
        echo "✅ Found at: $FOUND_SCRIPT"
        chmod +x "$FOUND_SCRIPT"
        "$FOUND_SCRIPT"
    else
        echo "❌ one_script.sh not found anywhere!"
    fi
fi

echo "✅ Auto-fix complete!"
