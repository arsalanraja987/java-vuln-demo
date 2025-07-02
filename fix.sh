#!/bin/bash

echo "🔍 Checking FileLoader.java for vulnerability..."

# File to check
FILE="FileLoader.java"

# Vulnerable line
VULN_LINE='File file = new File("/var/data/" + fileName);'

# Secure replacement code
SAFE_BLOCK='File baseDir = new File("/var/data/");
File file = new File(baseDir, fileName).getCanonicalFile();
if (!file.getPath().startsWith(baseDir.getCanonicalPath())) {
    throw new SecurityException("Invalid file path");
}'

# Check and fix
if grep -q "$VULN_LINE" "$FILE"; then
    echo "🚨 Vulnerability found. Fixing..."
    
    sed -i "s|$VULN_LINE|$SAFE_BLOCK|" "$FILE"

    git config --global user.name "AutoFix Bot"
    git config --global user.email "autofix@bot.com"
    git add "$FILE"
    git commit -m "Fix: Remediated path traversal vulnerability in FileLoader.java"
    git push origin main

    echo "✅ Fix committed and pushed successfully."
else
    echo "✔️ No vulnerable code found in $FILE"
fi
  
