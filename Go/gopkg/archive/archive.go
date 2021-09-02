// archive 解压缩相关的函数使用
// 打包和解包、解压和解压缩没涉及到复杂的算法，直接和文件的字节内容打交道
// 所以大多是 提取文件信息并填充 + copy 操作
package main

import (
	"archive/tar"
	"archive/zip"
	"fmt"
	"io"
	"os"
)

func main() {
	// 打包或 zip 压缩，都需要读取源文件的文件信息，再写入目标文件中
	// 最后直接将文件 copy 进去即可
	// Tar()   // 打包
	// Zip()   // 压缩

	// 解包或解压缩，都需要创建目标文件的 Reader
	// 遍历该 Reader 中的文件信息，逐个 copy 出来
	// 再创建文件即可
	// UnTar() // 解包
	// UnZip() // 解压缩
}

//
// zip 压缩与解压缩
//
func Zip() {
	// 创建 zip 压缩包
	zipF, _ := os.Create("games.zip")
	defer zipF.Close()
	zipW := zip.NewWriter(zipF) // 返回 Writer // 未实现 io.Writer 接口，不能通过 io.Copy() 直接写入字节数据
	defer zipW.Close()

	// 打开文件
	f, _ := os.Open("games.txt")
	defer f.Close()
	fInfo, _ := f.Stat()

	// 构造文件头
	h := zip.FileHeader{
		Name: fInfo.Name(),
	}
	// 写入文件头
	zipIOW, _ := zipW.CreateHeader(&h) // 返回 io.Writer

	// 写入文件内容
	buf := make([]byte, 0, fInfo.Size())
	f.Read(buf)
	zipIOW.Write(buf)
}

// 通过 zip.ReaderCloser 一次性批量读取文件信息，再遍历读取单个文件
func UnZip() {
	zipFiles, _ := zip.OpenReader("cities.zip")
	defer zipFiles.Close()

	// 遍历解压出来的文件
	for _, zipF := range zipFiles.File {
		r, _ := zipF.Open() // 创建 reader
		newF, _ := os.Create(zipF.FileInfo().Name())
		io.Copy(newF, r)
	}
}

//
// tar 打包与解包
//
func Tar() {
	// 创建 tar 包文件
	tarF, _ := os.Create("games.tar")
	defer tarF.Close()
	tarW := tar.NewWriter(tarF) // 返回 Writer，实现了 io.Writer 接口
	defer tarW.Close()

	// 打开文件并获取待打包文件的 FileInfo
	f, _ := os.Open("games.txt")
	defer f.Close()
	fInfo, _ := f.Stat()

	// 创建对应的 tar Header
	h := tar.Header{
		Name:    fInfo.Name(),
		Size:    fInfo.Size(),
		Mode:    int64(fInfo.Mode()),
		ModTime: fInfo.ModTime(),
	}

	// 先写入 header
	_ = tarW.WriteHeader(&h)
	// 再写入要打包的文件数据
	io.Copy(tarW, f)
}

// 通过 tar.Reader 来逐个向后解包文件
func UnTar() {
	tarF, _ := os.Open("cities.tar")
	defer tarF.Close()

	tarR := tar.NewReader(tarF) // 读取包中的当前文件全部内容
	for {
		fHeader, err := tarR.Next() // 逐个文件读取包中所有文件的文件头部信息
		if err == io.EOF {
			break
		}
		if err != nil {
			fmt.Println(err)
			return
		}

		fw, err := os.Create("./" + fHeader.Name)
		if err != nil {
			fmt.Println(err)
		}
		io.Copy(fw, tarR) // 解包一个文件的内容
	}
}
