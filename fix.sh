#!/bin/bash

echo "🔍 Checking FileLoader.java for vulnerability..."

if grep -q 'File file = new File("/var/data/" + fileName);' FileLoader.java; then
    echo "🚨 Vulnerability found. Applying fix..."

    sed -i 's|File file = new File("/var/data/" + fileName);|File baseDir = new File("/var/data/");\
File file = new File(baseDir, fileName).getCanonicalFile();\
if (!file.getPath().startsWith(baseDir.getCanonicalPath())) {\
    throw new SecurityException("Invalid file path");\
}|g' FileLoader.java

    git checkout -b main || git checkout main
    git pull origin main
    git add FileLoader.java
    git commit -m "Fix: Path Traversal Vulnerability"
    git push origin main

    echo "✅ Fix applied and pushed successfully."
else
    echo "✅ No vulnerability found i
