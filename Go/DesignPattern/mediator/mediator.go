/**
* @Author:zhoutao
* @Date:2020/12/12 上午9:52
* @Desc:
 */

package mediator

import (
	"fmt"
	"strings"
)

//中介模式：封装对象之间的交互，使依赖变得简单，并且是复杂交互简单化
//例子中的中介者使用单例模式生成

type CDDriver struct {
	Data string
}

func (c *CDDriver) ReadData() {
	c.Data = "music,image"
	fmt.Printf("CDDriver:reading data %s\n", c.Data)

}

type CPU struct {
	Video string
	Sound string
}

func (c *CPU) Process(data string) {
	sp := strings.Split(data, ",")
	c.Sound = sp[0]
	c.Video = sp[1]

	fmt.Printf("CPU:split data with Sound %s,Video %s\n", c.Sound, c.Video)
	GetMediatorInstance().changed(c)
}

type VideoCard struct {
	Data string
}

func (v *VideoCard) Display(data string) {
	v.Data = data
	fmt.Printf("VideoCard:display %s\n", v.Data)
	GetMediatorInstance().changed(v)
}

type SoundCard struct {
	Data string
}

func (s *SoundCard) Play(data string) {
	s.Data = data
	fmt.Printf("SoundCard:play %s\n", s.Data)
	GetMediatorInstance().changed(s)
}

//封装Mediator对象
type Mediator struct {
	CD    *CDDriver
	CPU   *CPU
	Video *VideoCard
	Sound *SoundCard
}

var mediator *Mediator

func GetMediatorInstance() *Mediator {
	if mediator == nil {
		mediator = &Mediator{}
	}
	return mediator
}

func (m *Mediator) changed(i interface{}) {
	switch inst := i.(type) {
	case *CDDriver:
		m.CPU.Process(inst.Data)
	case *CPU:
		m.Sound.Play(inst.Sound)
		m.Video.Display(inst.Video)
	}
}
