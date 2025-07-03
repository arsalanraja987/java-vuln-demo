import java.io.*;

public class FileLoader {
    public static void main(String[] args) throws IOException {
        String input = args[0];
        File file = new File(input); // 🛑 Vulnerable: path traversal
        BufferedReader reader = new BufferedReader(new FileReader(file));
        System.out.println(reader.readLine());
        reader.close();
    }
}
 
