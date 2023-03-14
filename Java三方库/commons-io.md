https://commons.apache.org/
## 引入依赖
```xml
<dependency>
    <groupId>commons-io</groupId>
    <artifactId>commons-io</artifactId>
    <version>2.11.0</version>
</dependency>
```
## FileUtils 文件操作工具类
```
文件夹操作： 
 copyDirectory/deleteDirectory/cleanDirectory/getTempDirectory/getTempDirectoryPath
 moveDirectory/moveDirectoryToDirectory/moveFileToDirectory/moveToDirectory
 forceMkdir/getUserDirectory/getUserDirectoryPath
文件操作：
	touch/copyFile/copyURLToFile/moveFile/deleteQuietly/forceDelete/forceDeleteOnExit
	toFile/toFiles/toURLs
	isFileNewer/isFileOlder
	readLines/readFileToByteArray/readFileToString/lineIterator/openOutputStream
	write/writeLines/writeByteArrayToFile/writeStringToFile/openInputStream
其他操作：
    iterateFiles/listFiles/contentEquals/sizeOf/sizeOfDirectory
```
## IOUtils 流操作工具类
```
读操作：lineIterator/read/readLines
写操作：write/writeLines
转换： toInputStream/toBufferedInputStream/toByteArray/toCharArray/toString
其他操作：copy/copyLarge/contentEquals/skip/skipFully/closeQuietly
```
## FilenameUtils 文件名工具类
```
获取：
	getName/getBaseName/getPrefix/getPrefixLength/getExtension
	getPath/getFullPath/getFullPathNoEndSeparator/getPathNoEndSeparator
判断：
	isExtension/equals/equalsNormalized/equalsOnSystem
其他操作：
	removeExtension/indexOfExtension
	separatorsToSystem/separatorsToUnix/separatorsToWindows
	indexOfLastSeparator
```
## 其他工具类
```
文件比较器：
    CompositeFileComparator/DefaultFileComparator/DirectoryFileComparator
    ExtensionFileComparator/LastModifiedFileComparator/NameFileComparator
    PathFileComparator/PathFileComparator
文件过滤器：
    AgeFileFilter/AndFileFilter/CanReadFileFilter/CanWriteFileFilter
    DelegateFileFilter/DirectoryFileFilter/EmptyFileFilter/FalseFileFilter/FileFileFilter
    FileFilterUtils/HiddenFileFilter/MagicNumberFileFilter/NameFileFilter/NotFileFilter
    OrFileFilter/PrefixFileFilter/RegexFileFilter/SizeFileFilter/SuffixFileFilter
    TrueFileFilter/WildcardFileFilter/WildcardFilter
```