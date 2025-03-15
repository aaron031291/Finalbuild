#!/usr/bin/env python3
import os
import subprocess

# Define directory and script names
dir_name = "blockchain_ui_components"
script_name = "blockchain_ui.py"
script_path = os.path.join(dir_name, script_name)

# Step 1: Create the directory if it doesn't exist
os.makedirs(dir_name, exist_ok=True)
print(f"✅ Directory created: {dir_name}")

# Step 2: Open nano to create/edit the script
subprocess.run(["nano", script_path])

# Step 3: Make the script executable
os.chmod(script_path, 0o755)
print(f"✅ Made script executable: {script_path}")

# Step 4: Ask if the user wants to run the script
run_script = input("Do you want to execute the script? (yes/no): ").strip().lower()
if run_script == "yes":
    subprocess.run(["python3", script_path])
    print(f"✅ Executed: {script_path}")
