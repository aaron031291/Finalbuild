#!/bin/bash

# Define directory and output file
DIR_NAME="recent_scripts"
OUTPUT_FILE="$DIR_NAME/combined_files.txt"

# Create the directory if it doesn't exist
mkdir -p "$DIR_NAME"

# Find all Python files modified in the last 3 days and concatenate them
find . -type f -name "*.py" -mtime -3 -print0 | xargs -0 cat > "$OUTPUT_FILE"

# Verify if files were concatenated
if [ -s "$OUTPUT_FILE" ]; then
    echo "All recently modified Python files have been combined into: $OUTPUT_FILE"
    ls -lh "$OUTPUT_FILE"
else
    echo "No Python files modified in the last 3 days."
fi

# Make itself executable
chmod +x "$0"

# Confirm execution
echo "One Script executed successfully."

