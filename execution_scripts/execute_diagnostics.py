#!/usr/bin/env python3

import os
import subprocess
import logging

# Set up logging
logging.basicConfig(filename="execution_diagnostics.log", level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

# Define the base directory
BASE_DIR = os.getcwd()  # Change if needed

# List all scripts
def get_python_scripts(base_dir):
    scripts = []
    for root, _, files in os.walk(base_dir):
        for file in files:
            if file.endswith(".py"):
                scripts.append(os.path.join(root, file))
    return scripts

# Run a script and capture output
def execute_script(script_path):
    logging.info(f"Executing: {script_path}")
    print(f"🚀 Running: {script_path}")

    try:
        result = subprocess.run(["python3", script_path], capture_output=True, text=True, timeout=20)
        if result.returncode == 0:
            print(f"✅ {script_path} executed successfully.")
            logging.info(f"✅ Success: {script_path}")
        else:
            print(f"❌ {script_path} failed with error:")
            print(result.stderr)
            logging.error(f"❌ Failed: {script_path} - {result.stderr}")
            suggest_fix(result.stderr, script_path)

    except subprocess.TimeoutExpired:
        print(f"⏳ {script_path} timed out.")
        logging.warning(f"⏳ Timeout: {script_path}")
    except Exception as e:
        print(f"🔥 Unexpected Error: {e}")
        logging.error(f"🔥 Unexpected Error in {script_path}: {e}")

# Suggest potential fixes
def suggest_fix(error_message, script_path):
    if "ModuleNotFoundError" in error_message:
        missing_module = error_message.split("'")[-2]
        fix_command = f"pip install {missing_module}"
        print(f"🛠 Suggested Fix: Install missing module `{missing_module}` using `{fix_command}`")
        logging.info(f"🛠 Suggested Fix for {script_path}: {fix_command}")

    elif "SyntaxError" in error_message:
        print(f"🔍 Suggested Fix: Check for syntax issues in `{script_path}`")
        logging.info(f"🔍 Syntax issue in {script_path}. Manual review needed.")

    elif "PermissionError" in error_message:
        fix_command = f"chmod +x {script_path}"
        print(f"🔑 Suggested Fix: Change permissions using `{fix_command}`")
        logging.info(f"🔑 Suggested Fix for {script_path}: {fix_command}")

    elif "FileNotFoundError" in error_message:
        print(f"📂 Suggested Fix: Ensure required files exist before running `{script_path}`")
        logging.info(f"📂 Suggested Fix: Missing file for {script_path}")

    else:
        print("⚠️ General Issue: Please review the error output above.")
        logging.info(f"⚠️ General Issue in {script_path}")

# Main execution loop
def main():
    scripts = get_python_scripts(BASE_DIR)
    print(f"🔎 Found {len(scripts)} Python scripts to execute.")

    for script in scripts:
        execute_script(script)

    print("🎯 Execution completed. Check `execution_diagnostics.log` for full details.")

if __name__ == "__main__":
    main()
