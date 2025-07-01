import re
import os
import subprocess

# Path to the file to check and fix
file_path = "FileLoader.java"

# Vulnerable line pattern (regex safe)
vuln_pattern = r'File file = new File\("/var/data/" \+ fileName\);'

# Secure replacement block
replacement_code = '''File baseDir = new File("/var/data/");
        File file = new File(baseDir, fileName).getCanonicalFile();
        if (!file.getPath().startsWith(baseDir.getCanonicalPath())) {
            throw new SecurityException("Invalid file path");
        }'''

def run_git_cmd(command):
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    print(result.stdout)
    if result.stderr:
        print("Git Error:", result.stderr)

def fix_file():
    if not os.path.exists(file_path):
        print(f"❌ File not found: {file_path}")
        return

    with open(file_path, 'r') as file:
        content = file.read()

    if 'File file = new File("/var/data/" + fileName);' not in content:
        print("✅ No vulnerability found.")
        return

    print("🔧 Vulnerability found. Applying fix...")

    # Replace the vulnerable line
    fixed_content = re.sub(vuln_pattern, replacement_code, content)

    # Overwrite the file
    with open(file_path, 'w') as file:
        file.write(fixed_content)

    # Git operations
    run_git_cmd("git config --global user.email \"bot@example.com\"")
    run_git_cmd("git config --global user.name \"AutoFix Bot\"")
    run_git_cmd(f"git add {file_path}")
    run_git_cmd("git commit -m \"fix: patch path traversal vulnerability in FileLoader.java\"")
    run_git_cmd("git push origin main")

    print("🚀 Fix committed and pushed!")

# Run the function
fix_file()
