#!/bin/bash

# Define directories
BASE_DIR="/workspaces/Finalbuild"
SOURCE_FILE="$BASE_DIR/combined_files.txt"

# Category directories (ensure these exist)
declare -A CATEGORIES
CATEGORIES=(
    ["ai_processing"]="$BASE_DIR/structured_codebase/ai_processing"
    ["blockchain_security"]="$BASE_DIR/structured_codebase/blockchain_security"
    ["core_infra"]="$BASE_DIR/structured_codebase/core_infra"
    ["edge_computing"]="$BASE_DIR/structured_codebase/edge_computing"
    ["monitoring"]="$BASE_DIR/structured_codebase/monitoring"
    ["ui_api"]="$BASE_DIR/structured_codebase/ui_api"
    ["mycelium"]="$BASE_DIR/structured_codebase/mycelium"
    ["rainbow_shield"]="$BASE_DIR/structured_codebase/rainbow_shield"
)

# Ensure all directories exist
for dir in "${CATEGORIES[@]}"; do
    mkdir -p "$dir"
done

# Read file line by line and move to correct category
while IFS= read -r file; do
    # Check if file exists
    if [[ -f "$BASE_DIR/$file" ]]; then
        for category in "${!CATEGORIES[@]}"; do
            if [[ "$file" == *"$category"* ]]; then
                mv "$BASE_DIR/$file" "${CATEGORIES[$category]}/"
                chmod +x "${CATEGORIES[$category]}/$(basename "$file")"
                echo "Moved & set executable: $file → ${CATEGORIES[$category]}"
                break
            fi
        done
    fi
done < "$SOURCE_FILE"

echo "✅ All scripts organized and made executable!"
