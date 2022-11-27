<!-- GFM-TOC -->
- [File IO](#file-io)
  - [0 File对象](#0-file对象)
    - [File](#file)
    - [RandomAccessFile](#randomaccessfile)
    - [NIO:Files](#niofiles)
  - [1 列出：list](#1-列出list)
    - [BIO](#bio)
  - [2 复制：copy](#2-复制copy)
    - [BIO](#bio-1)
    - [NIO](#nio)
    - [common-util](#common-util)
  - [3 删除：delete](#3-删除delete)
    - [NIO](#nio-1)
    - [apache commons-io](#apache-commons-io)
  - [4 创建create](#4-创建create)
    - [BIO：createNewFile](#biocreatenewfile)
    - [BIO：FileOutputStream](#biofileoutputstream)
    - [NIO](#nio-2)
  - [5 写入：wrirte\&append](#5-写入wrirteappend)
    - [BIO:BufferedWriter](#biobufferedwriter)
    - [BIO:PrintWriter](#bioprintwriter)
    - [BIO:FileOutputStream](#biofileoutputstream-1)
    - [BIO:DataOutputStream](#biodataoutputstream)
    - [NIO:FileChannel](#niofilechannel)
    - [NIO:Files静态方法](#niofiles静态方法)
  - [6 读取：read](#6-读取read)
    - [BIO:BufferedReader按行读](#biobufferedreader按行读)
    - [BIO:FileInputStream 读取字节](#biofileinputstream-读取字节)
    - [NIO:Files按行读](#niofiles按行读)
    - [NIO:读取所有字节](#nio读取所有字节)
    - [commons-io](#commons-io)
  - [7 Properties](#7-properties)
    - [补充：静态内部类与懒汉式单例模式](#补充静态内部类与懒汉式单例模式)
  - [8 Resource File](#8-resource-file)
    - [在spring中可以这样](#在spring中可以这样)
  - [10 读写utf8数据](#10-读写utf8数据)
  - [11 从控制台读取输入](#11-从控制台读取输入)
    - [console对象](#console对象)
    - [System.in封装](#systemin封装)
    - [更加复杂的Scanner](#更加复杂的scanner)
  - [12 将String转换成输入流](#12-将string转换成输入流)
    - [ByteArrayInputStream](#bytearrayinputstream)
    - [apach.IOUtils](#apachioutils)
<!-- GFM-TOC -->



# File IO



## 0 File对象

### File
java.io.File

File 类可以用于表示文件和目录的信息，但是它不表示文件的内容。有大量相关的方法

```java
File(String pathname)
File(URI uri)

createNewFile()
createTempFile(String prefix, String suffix)
delete()
deleteOnExit()
exists()
getAbsoluteFile()
getAbsolutePath()
getName()
getPath()
isFile()
isDirectory()
list()
listFiles()
mkdir()
mkdirs()
setReadOnly()
setExecutable(boolean executable)
setWritable(boolean writable)
toPath()
toURI()

```

### RandomAccessFile
java.io.RandomAccessFile

RandomAccessFile支持"随机访问"的方式，程序可以直接跳转到文件的任意地方来读写数据。

* RandomAccessFile可以自由访问文件的任意位置。
* RandomAccessFile允许自由定位文件记录指针。
* RandomAccessFile只能读写文件而不是流。

```java
RandomAccessFile(String name, String mode)：
RandomAccessFile(File file, String mode)

read*()
write*()
long getFilePointer()：返回文件记录指针的当前位置。(native方法)
void seek(long pos)：将文件记录指针定位到pos位置。(调用本地方法seek0)
```

* 使用randomaccessfile插入内容。RandomAccessFile依然不能向文件的指定位置插入内容，如果直接将文件记录指针移动到中间某位置后开始输出，则新输出的内容会覆盖文件中原有的内容。如果需要向指定位置插入内容，程序需要先把插入点后面的内容读入缓冲区，等把需要插入的数据写入文件后，再将缓冲区的内容追加到文件后面。

```java
  /**
     * 向指定文件的指定位置插入指定的内容
     *
     * @param fileName      指定文件名
     * @param pos           指定文件的指定位置
     * @param insertContent 指定文件的指定位置要插入的指定内容
     */
    public static void insert(String fileName, long pos,
                              String insertContent) throws IOException {
        RandomAccessFile raf = null;
        //创建一个临时文件来保存插入点后的数据
        File tmp = File.createTempFile("tmp", null);
        FileOutputStream tmpOut = null;
        FileInputStream tmpIn = null;
        tmp.deleteOnExit();
        try {
            raf = new RandomAccessFile(fileName, "rw");
            tmpOut = new FileOutputStream(tmp);
            tmpIn = new FileInputStream(tmp);
            raf.seek(pos);
            //--------下面代码将插入点后的内容读入临时文件中保存---------
            byte[] bbuf = new byte[64];
            //用于保存实际读取的字节数
            int hasRead = 0;
            //使用循环方式读取插入点后的数据
            while ((hasRead = raf.read(bbuf)) > 0) {
                //将读取的数据写入临时文件
                tmpOut.write(bbuf, 0, hasRead);
            }
            //----------下面代码插入内容----------
            //把文件记录指针重新定位到pos位置
            raf.seek(pos);
            //追加需要插入的内容
            raf.write(insertContent.getBytes());
            //追加临时文件中的内容
            while ((hasRead = tmpIn.read(bbuf)) > 0) {
                raf.write(bbuf, 0, hasRead);
            }
        } finally {
            if (raf != null) {
                raf.close();
            }
        }
    }
```

### NIO:Files

```java
Files.exists(path);     //true



```

## 1 列出：list

### BIO 
递归地列出一个目录下所有文件：

```java
public static void listAllFiles(File dir) {
    if (dir == null || !dir.exists()) {
        return;
    }
    if (dir.isFile()) {
        System.out.println(dir.getName());
        return;
    }
    for (File file : dir.listFiles()) {
        listAllFiles(file);
    }
}
```

从 Java7 开始，可以使用 Paths 和 Files 代替 File。


## 2 复制：copy
### BIO

```java
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * 利用文件输入流与输出流实现文件的复制操作
 */
public class CopyDemo {
  public static void main(String[] args) throws IOException {
    //用文件输入流读取待复制的文件
    FileInputStream fis = new FileInputStream("01.rmvb");
    //用文件输出流向复制文件中写入复制的数据
    FileOutputStream fos = new FileOutputStream("01_cp.rmvb");
    int d;//先定义一个变量，用于记录每次读取到的数据
    long start = System.currentTimeMillis();//获取当前系统时间
    while ((d = fis.read()) != -1) {
      fos.write(d);
    }
    long end = System.currentTimeMillis();
    System.out.println("复制完毕!耗时:" + (end - start) + "ms");
    fis.close();
    fos.close();
  }
}
//带缓冲区的
```java
public static void copyFile(String src, String dist) throws IOException {
    FileInputStream in = new FileInputStream(src);
    FileOutputStream out = new FileOutputStream(dist);

    byte[] buffer = new byte[20 * 1024];
    int cnt;

    // read() 最多读取 buffer.length 个字节
    // 返回的是实际读取的个数
    // 返回 -1 的时候表示读到 eof，即文件尾
    while ((cnt = in.read(buffer, 0, buffer.length)) != -1) {
        out.write(buffer, 0, cnt);
    }

    in.close();
    out.close();
}
```
### NIO
```java
package com.howtodoinjava.examples.io;
 
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
 
public class DirectoryCopyExample 
{
    public static void main(String[] args) throws IOException 
    {
        //Source directory which you want to copy to new location
        File sourceFolder = new File("c:\\temp");
         
        //Target directory where files should be copied
        File destinationFolder = new File("c:\\tempNew");
 
        //Call Copy function
        copyFolder(sourceFolder, destinationFolder);
    }
    /**
     * This function recursively copy all the sub folder and files from sourceFolder to destinationFolder
     * */
    private static void copyFolder(File sourceFolder, File destinationFolder) throws IOException
    {
        //Check if sourceFolder is a directory or file
        //If sourceFolder is file; then copy the file directly to new location
        if (sourceFolder.isDirectory()) 
        {
            //Verify if destinationFolder is already present; If not then create it
            if (!destinationFolder.exists()) 
            {
                destinationFolder.mkdir();
                System.out.println("Directory created :: " + destinationFolder);
            }
             
            //Get all files from source directory
            String files[] = sourceFolder.list();
             
            //Iterate over all files and copy them to destinationFolder one by one
            for (String file : files) 
            {
                File srcFile = new File(sourceFolder, file);
                File destFile = new File(destinationFolder, file);
                 
                //Recursive function call
                copyFolder(srcFile, destFile);
            }
        }
        else
        {
            //Copy the file content from one place to another 
            Files.copy(sourceFolder.toPath(), destinationFolder.toPath(), StandardCopyOption.REPLACE_EXISTING);
            System.out.println("File copied :: " + destinationFolder);
        }
    }
}
 
Output:
 
Directory created :: c:\tempNew
File copied :: c:\tempNew\testcopied.txt
File copied :: c:\tempNew\testoriginal.txt
File copied :: c:\tempNew\testOut.txt
```

### common-util

```java
private static void fileCopyUsingApacheCommons() throws IOException 
{
    File fileToCopy = new File("c:/temp/testoriginal.txt");
    File newFile = new File("c:/temp/testcopied.txt");
 
    FileUtils.copyFile(fileToCopy, newFile);
 
    // OR
 
    IOUtils.copy(new FileInputStream(fileToCopy), new FileOutputStream(newFile));
}
```

## 3 删除：delete

### NIO

```java
public class DeleteDirectoryNIOWithStream 
{
    public static void main(String[] args) 
    {
        Path dir = Paths.get("c:/temp/innerDir");
 
        Files.walk(dir)
            .sorted(Comparator.reverseOrder())
            .map(Path::toFile)
            .forEach(File::delete);
    }
}
```

### apache commons-io

```
public class DeleteDirectoryNIOWithStream 
{
    public static void main(String[] args) 
    {
        Path dir = Paths.get("c:/temp/innerDir");
 
        Files.walk(dir)
            .sorted(Comparator.reverseOrder())
            .map(Path::toFile)
            .forEach(File::delete);
    }
}
```

## 4 创建create

### BIO：createNewFile
File.createNewFile()方法创建新文件。 此方法返回布尔值–
* 如果文件创建成功，则返回true 。
* 如果文件已经存在或操作由于某种原因失败，则返回false 。
* 此方法不会像文件中写任何数据

```java
File file = new File("c://temp//testFile1.txt");
  
//Create the file
if (file.createNewFile())
{
    System.out.println("File is created!");
} else {
    System.out.println("File already exists.");
}
 
//Write Content
FileWriter writer = new FileWriter(file);
writer.write("Test data");
writer.close();
```
### BIO：FileOutputStream

FileOutputStream.write()方法自动创建一个新文件并向其中写入内容 。
```java
String data = "Test data";
 
FileOutputStream out = new FileOutputStream("c://temp//testFile2.txt");
 
out.write(data.getBytes());
out.close();
```

### NIO

Files.write()是创建文件的最佳方法，如果您尚未使用它，则应该是将来的首选方法。

此方法将文本行写入文件 。 每行都是一个char序列，并按顺序写入文件，每行由平台的line separator终止。

```java
String data = "Test data";
Files.write(Paths.get("c://temp//testFile3.txt"), data.getBytes());
 
//or
 
List<String> lines = Arrays.asList("1st line", "2nd line");
 
Files.write(Paths.get("file6.txt"), 
                lines, 
                StandardCharsets.UTF_8,
                StandardOpenOption.CREATE, 
                StandardOpenOption.APPEND);
```
## 5 写入：wrirte&append
* append模式，使用BufferedWritter ， PrintWriter ， FileOutputStream和Files类将内容追加到java中的 Files 。 在所有示例中，在打开要写入的文件时，您都传递了第二个参数true ，表示该文件以append mode打开

### BIO:BufferedWriter

通过BufferedWriter，进行更少的IO操作，提高了性能。

```java
public static void usingBufferedWritter() throws IOException 
{
    String fileContent = "Hello Learner !! Welcome to howtodoinjava.com.";
     
    BufferedWriter writer = new BufferedWriter(new FileWriter("c:/temp/samplefile1.txt"));
    writer.write(fileContent);
    writer.close();
}
```


### BIO:PrintWriter
使用PrintWriter将格式化的文本写入文件。
```java
public static void usingPrintWriter() throws IOException 
{
    String fileContent = "Hello Learner !! Welcome to howtodoinjava.com.";
     
    FileWriter fileWriter = new FileWriter("c:/temp/samplefile3.txt");
    PrintWriter printWriter = new PrintWriter(fileWriter);
    printWriter.print(fileContent);
    printWriter.printf("Blog name is %s", "howtodoinjava.com");
    printWriter.close();
}
```

### BIO:FileOutputStream

使用FileOutputStream 将二进制数据写入文件 。 FileOutputStream用于写入原始字节流，例如图像数据。 要编写字符流，请考虑使用FileWriter 。
```java
public static void usingFileOutputStream() throws IOException 
{
    String fileContent = "Hello Learner !! Welcome to howtodoinjava.com.";
     
    FileOutputStream outputStream = new FileOutputStream("c:/temp/samplefile4.txt");
    byte[] strToBytes = fileContent.getBytes();
    outputStream.write(strToBytes);
  
    outputStream.close();
}
```
### BIO:DataOutputStream

DataOutputStream允许应用程序以可移植的方式将原始Java数据类型写入输出流。 然后，应用程序可以使用数据输入流来读回数据。

```java
public static void usingDataOutputStream() throws IOException 
{
    String fileContent = "Hello Learner !! Welcome to howtodoinjava.com.";
     
    FileOutputStream outputStream = new FileOutputStream("c:/temp/samplefile5.txt");
    DataOutputStream dataOutStream = new DataOutputStream(new BufferedOutputStream(outputStream));
    dataOutStream.writeUTF(fileContent);
  
    dataOutStream.close();
}
```

### NIO:FileChannel

FileChannel可用于读取，写入，映射和操作文件。 如果要处理大文件，则FileChannel可能比标准IO快。

文件通道可以安全地供多个并发线程使用。

```java
public static void usingFileChannel() throws IOException 
{
    String fileContent = "Hello Learner !! Welcome to howtodoinjava.com.";
     
    RandomAccessFile stream = new RandomAccessFile("c:/temp/samplefile6.txt", "rw");
    FileChannel channel = stream.getChannel();
    byte[] strBytes = fileContent.getBytes();
    ByteBuffer buffer = ByteBuffer.allocate(strBytes.length);
    buffer.put(strBytes);
    buffer.flip();
    channel.write(buffer);
    stream.close();
    channel.close();
}
```


### NIO:Files静态方法

```java
public static void usingPath() throws IOException 
{
    String fileContent = "Hello Learner !! Welcome to howtodoinjava.com.";
     
    Path path = Paths.get("c:/temp/samplefile7.txt");
  
    Files.write(path, fileContent.getBytes());
}

public static void usingPath() throws IOException 
{
    String textToAppend = "\r\n Happy Learning !!"; //new line in content
     
    Path path = Paths.get("c:/temp/samplefile.txt");
  
    Files.write(path, textToAppend.getBytes(), StandardOpenOption.APPEND);  //Append mode
}
```


## 6 读取：read
### BIO:BufferedReader按行读

```java
//Using BufferedReader and FileReader - Below Java 7
 
private static String usingBufferedReader(String filePath) 
{
    StringBuilder contentBuilder = new StringBuilder();
    try (BufferedReader br = new BufferedReader(new FileReader(filePath))) 
    {
 
        String sCurrentLine;
        while ((sCurrentLine = br.readLine()) != null) 
        {
            contentBuilder.append(sCurrentLine).append("\n");
        }
    } 
    catch (IOException e) 
    {
        e.printStackTrace();
    }
    return contentBuilder.toString();
```

### BIO:FileInputStream 读取字节

```java
import java.io.File;
import java.io.FileInputStream;
 
public class ContentToByteArrayExample
{
   public static void main(String[] args)
   {
       
      File file = new File("C:/temp/test.txt");
       
      readContentIntoByteArray(file);
   }
 
   private static byte[] readContentIntoByteArray(File file)
   {
      FileInputStream fileInputStream = null;
      byte[] bFile = new byte[(int) file.length()];
      try
      {
         //convert file into array of bytes
         fileInputStream = new FileInputStream(file);
         fileInputStream.read(bFile);
         fileInputStream.close();
         for (int i = 0; i < bFile.length; i++)
         {
            System.out.print((char) bFile[i]);
         }
      }
      catch (Exception e)
      {
         e.printStackTrace();
      }
      return bFile;
   }
}
```
### NIO:Files按行读

lines()方法从文件中读取所有行以进行流传输，并在stream被消耗时延迟填充。 使用指定的字符集将文件中的字节解码为字符。
readAllBytes()方法reads all the bytes from a file 。 该方法可确保在读取所有字节或引发I / O错误或其他运行时异常时关闭文件。
```java
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.stream.Stream;
 
public class ReadFileToString 
{
    public static void main(String[] args) 
    {
        String filePath = "c:/temp/data.txt";
 
        System.out.println( readLineByLineJava8( filePath ) );
    }
 
 
    //Read file content into string with - Files.lines(Path path, Charset cs)
 
    private static String readLineByLineJava8(String filePath) 
    {
        StringBuilder contentBuilder = new StringBuilder();
 
        try (Stream<String> stream = Files.lines( Paths.get(filePath), StandardCharsets.UTF_8)) 
        {
            stream.forEach(s -> contentBuilder.append(s).append("\n"));
        }
        catch (IOException e) 
        {
            e.printStackTrace();
        }
 
        return contentBuilder.toString();
    }
}
```

### NIO:读取所有字节


读取所有字节后，我们将这些字节传递给String类构造函数以创建一个字符串
```java
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
 
public class ReadFileToString 
{
    public static void main(String[] args) 
    {
        String filePath = "c:/temp/data.txt";
 
        System.out.println( readAllBytesJava7( filePath ) );
    }
 
    //Read file content into string with - Files.readAllBytes(Path path)
 
    private static String readAllBytesJava7(String filePath) 
    {
        String content = "";
 
        try
        {
            content = new String ( Files.readAllBytes( Paths.get(filePath) ) );
        } 
        catch (IOException e) 
        {
            e.printStackTrace();
        }
 
        return content;
    }
}
```

### commons-io

```java
//Using FileUtils.readFileToByteArray()
byte[] org.apache.commons.io.FileUtils.readFileToByteArray(File file)
 
//Using IOUtils.toByteArray
byte[] org.apache.commons.io.IOUtils.toByteArray(InputStream input) 
```

## 7 Properties

任何复杂的应用程序都需要某种配置。 有时我们需要将此配置为只读（通常在应用程序启动时读取），有时（或很少）我们需要写回或更新这些属性配置文件上的内容。

在这个简单易用的教程中，学习使用Properties.load()方法读取Java中的Properties.load() 文件 。 然后，我们将使用Properties.setProperty()方法将新属性写入file 。

* 创建单实例的属性文件



```java
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.Set;
 
public class PropertiesCache
{
   private final Properties configProp = new Properties();
    
   private PropertiesCache()
   {
      //Private constructor to restrict new instances
      InputStream in = this.getClass().getClassLoader().getResourceAsStream("app.properties");
      System.out.println("Read all properties from file");
      try {
          configProp.load(in);
      } catch (IOException e) {
          e.printStackTrace();
      }
   }
 
   //Bill Pugh Solution for singleton pattern
   private static class LazyHolder
   {
      private static final PropertiesCache INSTANCE = new PropertiesCache();
   }
 
   public static PropertiesCache getInstance()
   {
      return LazyHolder.INSTANCE;
   }
    
   public String getProperty(String key){
      return configProp.getProperty(key);
   }
    
   public Set<String> getAllPropertyNames(){
      return configProp.stringPropertyNames();
   }
    
   public boolean containsKey(String key){
      return configProp.containsKey(key);
   }
}
```

### 补充：静态内部类与懒汉式单例模式

这种方式是当被调用getInstance()时才去加载静态内部类LazyHolder，LazyHolder在加载过程中会实例化一个静态的Singleton，因为利用了classloader的机制来保证初始化instance时只有一个线程，所以Singleton肯定只有一个，是线程安全的，这种比上面1、2都好一些，既实现了线程安全，又避免了同步带来的性能影响。

```java
public class Singleton {  
    private static class LazyHolder {  
       private static final Singleton INSTANCE = new Singleton();  
    }  
    private Singleton (){}  
    public static final Singleton getInstance() {  
       return LazyHolder.INSTANCE;  
    }  
} 
```

## 8 Resource File

ClassLoader引用从应用程序的资源包中读取文件。加载上下文环境中的文件。

```java
package com.howtodoinjava.demo;
 
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
 
public class ReadResourceFileDemo 
{
    public static void main(String[] args) throws IOException 
    {
        String fileName = "config/sample.txt";
        ClassLoader classLoader = new ReadResourceFileDemo().getClass().getClassLoader();
 
        File file = new File(classLoader.getResource(fileName).getFile());
         
        //File is found
        System.out.println("File Found : " + file.exists());
         
        //Read File Content
        String content = new String(Files.readAllBytes(file.toPath()));
        System.out.println(content);
    }
}
```

### 在spring中可以这样

```java
File file = ResourceUtils.getFile("classpath:config/sample.txt")
 
//File is found
System.out.println("File Found : " + file.exists());
 
//Read File Content
String content = new String(Files.readAllBytes(file.toPath()));
System.out.println(content);

```


## 10 读写utf8数据

```java
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
 
public class WriteUTF8Data
{
   public static void main(String[] args)
   {
      try
      {
         File fileDir = new File("c:\\temp\\test.txt");
         Writer out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(fileDir), "UTF8"));
         out.append("Howtodoinjava.com").append("\r\n");
         out.append("UTF-8 Demo").append("\r\n");
         out.append("क्षेत्रफल = लंबाई * चौड़ाई").append("\r\n");
         out.flush();
         out.close();
      } catch (UnsupportedEncodingException e)
      {
         System.out.println(e.getMessage());
      } catch (IOException e)
      {
         System.out.println(e.getMessage());
      } catch (Exception e)
      {
         System.out.println(e.getMessage());
      }
   }
}
```

```java
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
 
public class ReadUTF8Data
{
   public static void main(String[] args)
   {
      try {
         File fileDir = new File("c:\\temp\\test.txt");
   
         BufferedReader in = new BufferedReader(
            new InputStreamReader(
                       new FileInputStream(fileDir), "UTF8"));
   
         String str;
   
         while ((str = in.readLine()) != null) {
             System.out.println(str);
         }
   
                 in.close();
         } 
         catch (UnsupportedEncodingException e) 
         {
             System.out.println(e.getMessage());
         } 
         catch (IOException e) 
         {
             System.out.println(e.getMessage());
         }
         catch (Exception e)
         {
             System.out.println(e.getMessage());
         }
   }
}
```


## 11 从控制台读取输入

### console对象
```java
private static void usingConsoleReader()
{
  Console console = null;
  String inputString = null;
  try
  {
     // creates a console object
     console = System.console();
     // if console is not null
     if (console != null)
     {
        // read line from the user input
        inputString = console.readLine("Name: ");
        // prints
        System.out.println("Name entered : " + inputString);
     }
  } catch (Exception ex)
  {
     ex.printStackTrace();
  }
}
```

### System.in封装

```java
private static void usingBufferedReader()
{
  System.out.println("Name: ");
  try{
     BufferedReader bufferRead = new BufferedReader(new InputStreamReader(System.in));
     String inputString = bufferRead.readLine();
      
     System.out.println("Name entered : " + inputString);
 }
 catch(IOException ex)
 {
    ex.printStackTrace();
 }
}  
```

### 更加复杂的Scanner
```java
private static void usingScanner()
{
  System.out.println("Name: ");
   
  Scanner scanIn = new Scanner(System.in);
  String inputString = scanIn.nextLine();
 
  scanIn.close();            
  System.out.println("Name entered : " + inputString);
}
```


## 12 将String转换成输入流

### ByteArrayInputStream
```java
import java.io.ByteArrayInputStream;
import java.io.InputStream;
 
public class ConvertStringToInputStreamExample
{
   public static void main(String[] args)
   {
      String sampleString = "howtodoinjava.com";
       
      //Here converting string to input stream
      InputStream stream = new ByteArrayInputStream(sampleString.getBytes());
   }
}
```

### apach.IOUtils

```java
import java.io.InputStream;
import org.apache.commons.io.IOUtils;
 
public class ConvertStringToInputStreamExample
{
   public static void main(String[] args)
   {
      String sampleString = "howtodoinjava.com";
       
      //Here converting string to input stream
      InputStream stream = IOUtils.toInputStream(sampleString);
   }
}
```