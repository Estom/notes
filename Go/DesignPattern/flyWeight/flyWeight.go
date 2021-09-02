/**
* @Author:zhoutao
* @Date:2020/12/11 下午2:55
* @Desc:
 */

package flyWeight

import "fmt"

// 享元模式：从对象中剥离不发生改变，并且多个实例需要的重复数据，独立出来一个享元，让多个对象来共享，从而节省内存以及减少对象数量

type ImageFlyWeightFactory struct {
	maps map[string]*ImageFlyWeight
}

var imageFatory *ImageFlyWeightFactory

func GetImageFlyFactory() *ImageFlyWeightFactory {
	if imageFatory == nil {
		imageFatory = &ImageFlyWeightFactory{
			maps: make(map[string]*ImageFlyWeight),
		}
	}
	return imageFatory
}
func (f *ImageFlyWeightFactory) Get(filename string) *ImageFlyWeight {
	image := f.maps[filename]
	if image == nil {
		image = NewImageFlyWeight(filename)
		f.maps[filename] = image
	}
	return image
}

func NewImageFlyWeight(filename string) *ImageFlyWeight {
	//load image file
	data := fmt.Sprintf("image data %s", filename)
	return &ImageFlyWeight{
		data: data,
	}
}

type ImageFlyWeight struct {
	data string
}

func (i *ImageFlyWeight) Data() string {
	return i.data
}

func NewImageViewr(filename string) *ImageViewer {
	image := GetImageFlyFactory().Get(filename)
	return &ImageViewer{
		ImageFlyWeight: image,
	}
}

type ImageViewer struct {
	*ImageFlyWeight
}

func (i *ImageViewer) Display() {
	fmt.Printf("Display:%s\n", i.Data())
}
