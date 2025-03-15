#!/bin/bash

# Define base directories
BASE_DIR="./structured_codebase"
LOGS_DIR="./logs"
MERGED_SCRIPT="combined_recent_files.txt"

# Ensure directories exist
mkdir -p $BASE_DIR/{core_infra,ai_processing,blockchain_security,edge_computing,monitoring,ui_api}
mkdir -p $LOGS_DIR

# Define file counters
infra_count=0
ai_count=0
blockchain_count=0
edge_count=0
monitor_count=0
ui_count=0

# Categorization Function
categorize_script() {
    local script_content="$1"
    local script_path="$2"

    # Identify category based on keywords
    if grep -qiE "kernel|memory|storage|compute" <<< "$script_content"; then
        mv "$script_path" "$BASE_DIR/core_infra/"
        ((infra_count++))
    elif grep -qiE "ai|self-healing|optimization|learning" <<< "$script_content"; then
        mv "$script_path" "$BASE_DIR/ai_processing/"
        ((ai_count++))
    elif grep -qiE "blockchain|consensus|ledger|hash" <<< "$script_content"; then
        mv "$script_path" "$BASE_DIR/blockchain_security/"
        ((blockchain_count++))
    elif grep -qiE "edge|distributed|mycelium|networking" <<< "$script_content"; then
        mv "$script_path" "$BASE_DIR/edge_computing/"
        ((edge_count++))
    elif grep -qiE "error|debug|logs|diagnostics" <<< "$script_content"; then
        mv "$script_path" "$BASE_DIR/monitoring/"
        ((monitor_count++))
    elif grep -qiE "ui|interface|api|terminal" <<< "$script_content"; then
        mv "$script_path" "$BASE_DIR/ui_api/"
        ((ui_count++))
    fi
}

# Process merged script and split into categorized files
split_and_categorize() {
    echo "Processing and categorizing scripts..."

    # Read the merged script line-by-line and separate scripts
    awk '
    BEGIN { RS="^#!/bin/bash" } 
    {
        script_content = "#!/bin/bash" $0
        script_name = "script_" NR ".sh"
        print script_content > script_name
        close(script_name)
        system("chmod +x " script_name)
    }' "$MERGED_SCRIPT"

    # Loop through generated scripts and categorize
    for script in script_*.sh; do
        [ -f "$script" ] || continue
        categorize_script "$(cat "$script")" "$script"
    done

    echo "Categorization complete!"
}

# Debugging & Validation Function
validate_scripts() {
    echo "Running diagnostics..."

    # Run all categorized scripts to check execution validity
    for category in $BASE_DIR/*; do
        echo "Validating scripts in: $category"
        for script in "$category"/*.sh; do
            [ -f "$script" ] || continue
            bash "$script" > "$LOGS_DIR/$(basename "$script").log" 2>&1
            if [ $? -eq 0 ]; then
                echo "[SUCCESS] $(basename "$script") executed successfully!"
            else
                echo "[ERROR] $(basename "$script") failed! Check logs."
            fi
        done
    done
}

# Execute the workflow
split_and_categorize
validate_scripts

echo "✅ All scripts processed, categorized, and validated!"
