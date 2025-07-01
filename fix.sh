#!/bin/bash

echo "🔍 Checking FileLoader.java for vulnerability..."

if grep -q 'File file = new File("/var/data/" + fileName);' FileLoader.java; then
    echo "🚨 Vulnerability found. Applying fix..."

    # Delete the vulnerable line
    sed -i '/File file = new File("\/var\/data\/" + fileName);/d' FileLoader.java

    # Append safe replacement
    cat << 'EOF' >> FileLoader.java
File baseDir = new File("/var/data/");
File file = new File(baseDir, fileName).getCanonicalFile();
if (!file.getPath().startsWith(baseDir.getCanonicalPath())) {
    throw new SecurityException("Invalid file path");
}
EOF

    git checkout -b main || git checkout main
    git pull origin main
    git add FileLoader.java
    git c
