#!/bin/bash

echo "🚀 Auto-Sync System Initializing..."

# Directories to scan
SCRIPT_DIRS=("blockchain" "ai" "security" "transactions" "consensus" "edge" "crosschain" "smartcontracts" "ui")

# Ensure integrated directory exists
mkdir -p integrated

# Ensure scripts are executable
echo "🔹 Setting scripts as executable..."
find "${SCRIPT_DIRS[@]}" -type f \( -name "*.js" -o -name "*.py" -o -name "*.sh" \) -exec chmod +x {} \;

# Dynamically pull existing scripts without duplication
echo "�� Integrating existing scripts dynamically..."
for dir in "${SCRIPT_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    for script in "$dir"/*.{js,py,sh}; do
      [ -f "$script" ] || continue
      ln -sf "$(realpath $script)" "./integrated/$(basename "$script")"
      echo "✅ Linked $script"
    done
  else
    echo "⚠️ Directory $dir not found, skipping..."
  fi
done

# Create blockchain immutable logs and KPI logs
LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
BLOCKCHAIN_LOG="$LOG_DIR/blockchain_immutable.log"
KPI_LOG="$LOG_DIR/kpi.log"

echo "🔗 Initializing blockchain immutable logs..."
echo "$(date) - Blockchain Logs Initialized" >> "$BLOCKCHAIN_LOG"
echo "📈 KPI logging initialized..." > "$LOG_DIR/kpi.log"

echo "✅ Auto-Sync System initialized successfully."
