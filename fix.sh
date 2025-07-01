#!/bin/bash

echo "🔍 Checking FileLoader.java for vulnerability..."

# File path to fix
FILE="FileLoader.java"

# Vulnerable pattern to look for
VULN_LINE='File file = new File("/var/data/" + fileName);'

# Safe replacement block
SAFE_BLOCK='File baseDir = new File("/var/data/");
File file = new File(baseDir, fileName).getCanonicalFile();
if (!file.getPath().startsWith(baseDir.getCanonicalPath())) {
    throw new SecurityException("Invalid file path");
}'

# Check if the vulnerable line exists
if grep -q "$VULN_LINE" "$FILE"; then
    echo "🚨 Vulnerability found. Applying fix..."

    # Replace the vulnerable line with safe code
    sed -i "s|$VULN_LINE|$SAFE_BLOCK|" "$FILE"

    # Git setup
    git config --global user.name "AutoFix Bot"
    git config --global user.email "autofix@bot.com"

    # Ensure we are on the correct branch
    git checkout main

    # Pull the latest changes to avoid conflicts
    git pull origin main

    # Stage and commit the change
    git add "$FILE"
    git commit -m "Fix: Auto-remediated path traversal vulnerability"

    # Push to main branch
    git push origin main

    echo "✅ Fix applied and pushed successfully."
else
    echo "✔️ No vulnerable pattern found. Nothing to fix."
fi
