/**
* @Author:zhoutao
* @Date:2020/12/12 上午10:58
* @Desc:
 */

package command

import "fmt"

//命令模式:本质是把某个对象的"方法调用"-》封装到对象中，方便传输、存储、调用
//使用命令模式还可以用作： 批处理、任务队列、undo,redo等，

type Command interface {
	Execute()
}

//MotherBoard
type MotherBoard struct {
}

func (*MotherBoard) Start() {
	fmt.Print("system starting\n")
}

func (*MotherBoard) Reboot() {
	fmt.Print("system rebooting\n")
}

//NewStart
func NewStartCommand(mb *MotherBoard) *StartCommand {
	return &StartCommand{
		mb: mb,
	}
}

// 将启动操作封装到了StartCommand对象中
type StartCommand struct {
	mb *MotherBoard
}

func (s *StartCommand) Execute() {
	s.mb.Start()
}

//NewReboot
func NewRebootCommand(mb *MotherBoard) *RebootCommond {
	return &RebootCommond{
		mb: mb,
	}
}

// 将reboot操作封装到了额RebootCommond对象中
type RebootCommond struct {
	mb *MotherBoard
}

func (r *RebootCommond) Execute() {
	r.mb.Reboot()
}

//NewBox
func NewBox(button1, button2 Command) *Box {
	return &Box{
		button1: button1,
		button2: button2,
	}
}

type Box struct {
	button1 Command
	button2 Command
}

func (b *Box) PressButton1() {
	b.button1.Execute()
}

func (b *Box) PressButton2() {
	b.button2.Execute()
}
