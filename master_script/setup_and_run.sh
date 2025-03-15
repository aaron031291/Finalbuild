#!/bin/bash

# Set directory and script name
DIR="/workspaces/Finalbuild/my_script_directory"
SCRIPT_NAME="my_script.sh"
SCRIPT_PATH="$DIR/$SCRIPT_NAME"

# Create the directory if it doesn’t exist
if [ ! -d "$DIR" ]; then
    mkdir -p "$DIR"
    echo "Directory created: $DIR"
else
    echo "Directory already exists: $DIR"
fi

# Create the script file if it doesn’t exist
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "#!/bin/bash" > "$SCRIPT_PATH"
    echo "echo 'Script is running...'" >> "$SCRIPT_PATH"
    echo "Script created: $SCRIPT_PATH"
else
    echo "Script already exists: $SCRIPT_PATH"
fi

# Open the script in nano for editing
nano "$SCRIPT_PATH"

# Make the script executable
chmod +x "$SCRIPT_PATH"
echo "Script is now executable."

# Run the script
"$SCRIPT_PATH"

