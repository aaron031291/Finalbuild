#!/bin/bash

echo "🚀 AI Script Optimizer: Making all scripts executable & optimizing..."

# Define directories to search
SCRIPT_DIRS=("blockchain" "ai" "security" "transactions" "edge" "ui" "integrated")

# Make all scripts executable
for DIR in "${SCRIPT_DIRS[@]}"; do
    if [ -d "$DIR" ]; then
        find "$DIR" -type f -name "*.sh" -exec chmod +x {} \;
        find "$DIR" -type f -name "*.py" -exec chmod +x {} \;
        find "$DIR" -type f -name "*.js" -exec chmod +x {} \;
    fi
done

echo "✅ All scripts are now executable."

# AI Optimization Phase (Rewrites code dynamically)
echo "🚀 Running AI optimization..."
node ai_script_optimizer.js

echo "✅ AI Optimization complete."
