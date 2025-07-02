import java.io.File;

public class FileLoader {
    public static void main(String[] args) {
        String fileName = "../../etc/passwd"; // Simulating attacker input
        File file = new File("/var/data/" + fileName); // 🚨 VULNERABLE CODE
        System.out.println("Loading file: " + file.getPath());
    }
}

 
