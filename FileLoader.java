public class FileLoader {
    public void load(String fileName) {
        File file = new File("/var/data/" + fileName);
        System.out.println(file.getPath());
    }
}
