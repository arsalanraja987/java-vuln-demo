#!/bin/bash

echo "🔍 Scanning for vulnerable FileLoader.java..."
FILE="FileLoader.java"

if grep -q 'File file = new File("/var/data/" + fileName);' "$FILE"; then
    echo "🚨 Vulnerability found in $FILE"
    echo "🛠️  Applying fix..."

    cat > "$FILE" <<'EOF'
import java.io.File;
import java.io.IOException;

public class FileLoader {
    public static void main(String[] args) throws IOException {
        String fileName = "../../etc/passwd"; // Simulated user input
        File baseDir = new File("/var/data/");
        File file = new File(baseDir, fileName).getCanonicalFile();

        if (!file.getPath().startsWith(baseDir.getCanonicalPath())) {
            throw new SecurityException("Invalid file path");
        }

        System.out.println("Loading file: " + file.getPath());
    }
}
EOF

    echo "✅ Fix applied successfully."

    git config --global user.name "AutoFix Bot"
    git config --global user.email "bot@example.com"
    git add "$FILE"
    git commit -m "Fix: Auto-remediated path traversal vulnerability"
    git push
else
    echo "✅ No vulnerability found."
fi
