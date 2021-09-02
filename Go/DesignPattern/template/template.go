package template

import "fmt"

//模板模式:模板模式使用集成机制，把通用的步骤和通用方法放到父类中，把具体实现延迟到子类中实现。是的实现符合开闭原则
//golang中不提供继承，需要使用匿名组合模拟实现继承
//此处需要注意：因为父类需要调用子类方法，所以子类需要匿名组合父类的同时，父类需要持有子类的引用

type Downloader interface {
	Download(uri string)
}

type implement interface {
	download()
	save()
}

//newTemplate
func newTemplate(impl implement) *template {
	return &template{
		implement: impl,
	}
}

type template struct {
	implement
	uri string
}

func (t *template) Download(uri string) {
	t.uri = uri
	fmt.Print("prepare to download\n")

	t.implement.download()
	t.implement.save()
	fmt.Print("finish download\n")
}

func (t *template) save() {
	fmt.Print("default save\n")
}

//NewHTTPDownloader
func NewHTTPDownloader() Downloader {
	downloader := &HTTPDownloader{}
	template := newTemplate(downloader)
	downloader.template = template
	return downloader
}

type HTTPDownloader struct {
	*template
}

func (h *HTTPDownloader) download() {
	fmt.Printf("download %s via http\n", h.uri)
}

func (*HTTPDownloader) save() {
	fmt.Printf("http save\n")
}

//NewFTPDownloader
func NewFTPDownloader() Downloader {
	downloader := &FPTDownloader{}
	template := newTemplate(downloader)
	downloader.template = template
	return downloader
}

type FPTDownloader struct {
	*template
}

func (f *FPTDownloader) download() {
	fmt.Printf("download %s via ftp\n", f.uri)
}
