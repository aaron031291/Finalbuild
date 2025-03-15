#!/bin/bash

# Define source and target directories
SOURCE_FILE="/workspaces/Finalbuild/master_script/combined_recent_files.txt"
DEST_DIR="/workspaces/Finalbuild/structured_codebase"

# Ensure target directories exist
mkdir -p "$DEST_DIR/ai_processing"
mkdir -p "$DEST_DIR/blockchain_security"
mkdir -p "$DEST_DIR/core_infra"
mkdir -p "$DEST_DIR/edge_computing"
mkdir -p "$DEST_DIR/monitoring"
mkdir -p "$DEST_DIR/ui_api"
mkdir -p "$DEST_DIR/mycelium"
mkdir -p "$DEST_DIR/rainbow_shield"

# Categorize and sort files
echo "Categorizing and sorting files..."

awk '
/\*\* AI Processing \*\*/ {section="ai_processing"}
/\*\* Blockchain Security \*\*/ {section="blockchain_security"}
/\*\* Core Infrastructure \*\*/ {section="core_infra"}
/\*\* Edge Computing \*\*/ {section="edge_computing"}
/\*\* Monitoring \*\*/ {section="monitoring"}
/\*\* UI API \*\*/ {section="ui_api"}
/\*\* Mycelium \*\*/ {section="mycelium"}
/\*\* Rainbow Shield \*\*/ {section="rainbow_shield"}
section {print > "'"$DEST_DIR"'/" section "/sorted_component.txt"}
' "$SOURCE_FILE"

echo "Categorization complete!"
