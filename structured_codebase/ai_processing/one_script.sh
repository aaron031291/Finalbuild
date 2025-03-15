#!/bin/bash

# ==========================
# 🚀 MASTER ONE SCRIPT SYSTEM
# ==========================

LOG_FILE="/workspaces/Finalbuild/logs/one_script.log"

echo "🚀 One Script System Initialized..." | tee -a $LOG_FILE

# ✅ Step 1: Auto-Sync & Real-Time Memory Update
echo "🔄 Updating real-time memory & syncing latest changes..." | tee -a $LOG_FILE
if [ -f "/workspaces/Finalbuild/auto_sync_system/auto_sync.sh" ]; then
    source /workspaces/Finalbuild/auto_sync_system/auto_sync.sh
else
    echo "⚠ Auto-Sync script not found!" | tee -a $LOG_FILE
fi

# ✅ Step 2: Deduplication & Auto-Update
echo "🛠 Running deduplication and auto-update..." | tee -a $LOG_FILE
if [ -f "/workspaces/Finalbuild/deduplication_engine/deduplicate.sh" ]; then
    source /workspaces/Finalbuild/deduplication_engine/deduplicate.sh
fi
if [ -f "/workspaces/Finalbuild/auto_update_engine/update_scripts.sh" ]; then
    source /workspaces/Finalbuild/auto_update_engine/update_scripts.sh
fi

# ✅ Step 3: Categorization & Execution Routing
echo "📡 Categorizing and routing scripts..." | tee -a $LOG_FILE
for file in /workspaces/Finalbuild/combined_files/*.sh; do
    if grep -q "AI_PROCESSING" "$file"; then
        mv "$file" /workspaces/Finalbuild/structured_codebase/ai_processing/
    elif grep -q "BLOCKCHAIN_SECURITY" "$file"; then
        mv "$file" /workspaces/Finalbuild/structured_codebase/blockchain_security/
    elif grep -q "EDGE_COMPUTING" "$file"; then
        mv "$file" /workspaces/Finalbuild/structured_codebase/edge_computing/
    elif grep -q "MYCELIUM" "$file"; then
        mv "$file" /workspaces/Finalbuild/structured_codebase/mycelium/
    elif grep -q "RAINBOW_SHIELD" "$file"; then
        mv "$file" /workspaces/Finalbuild/structured_codebase/rainbow_shield/
    else
        echo "⚠ Unsorted script: $file" | tee -a $LOG_FILE
    fi
done

# ✅ Step 4: Security & Permissions
echo "🔧 Making all scripts executable..." | tee -a $LOG_FILE
find /workspaces/Finalbuild/structured_codebase/ -type f -name "*.sh" -exec chmod +x {} \;

# ✅ Step 5: Structured Execution
echo "🚀 Executing categorized scripts..." | tee -a $LOG_FILE
for dir in /workspaces/Finalbuild/structured_codebase/*; do
    for script in "$dir"/*.sh; do
        echo "⚡ Running: $script" | tee -a $LOG_FILE
        bash "$script"
    done
done

# ✅ Step 6: Logging & Self-Healing
echo "🔍 Checking execution logs..." | tee -a $LOG_FILE
if grep -q "ERROR" "$LOG_FILE"; then
    echo "⚠ Errors detected! Running self-healing protocols..." | tee -a $LOG_FILE
    source /workspaces/Finalbuild/error_handling_engine/fix_errors.sh
else
    echo "✅ All scripts executed successfully!" | tee -a $LOG_FILE
fi

# ✅ Final Step: Completion Log
echo "✅ Master One Script Execution Complete!" | tee -a $LOG_FILE
