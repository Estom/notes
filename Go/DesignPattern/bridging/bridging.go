package bridging

import "fmt"

//桥接模式：分离抽象部分和是实现部分，使得两部分可以独立变化
//桥接模式类似于策略模式，区别于策略模式封装一些列算法，使得算法可以相互替换

//将抽象部分SendMessage()与具体的实现部分Send()分离

//抽象部分:SendMessage
type AbstractMessage interface {
	SendMessage(text, to string)
}

//实现部分:Send
type MessageImplementer interface {
	Send(text, to string)
}

//via sms
func ViaSMS() MessageImplementer {
	return &MessageSMS{}
}

type MessageSMS struct {
}

func (*MessageSMS) Send(text, to string) {
	fmt.Printf("send %s to %s via SMS", text, to)
}

//via email
func ViaEmail() MessageImplementer {
	return &MessageEmail{}
}

type MessageEmail struct {
}

func (MessageEmail) Send(text, to string) {
	fmt.Printf("send %s to via Email", text, to)
}

//New commonMessage,method can be SMS or email
func NewCommonMessage(method MessageImplementer) *CommonMessage {
	return &CommonMessage{
		method: method,
	}
}

type CommonMessage struct {
	method MessageImplementer
}

func (c *CommonMessage) SendMessage(text, to string) {
	c.method.Send(text, to)
}

//New UrgencyMessage,method can be SMS or email
func NewUrgencyMessage(method MessageImplementer) *UrgencyMessage {
	return &UrgencyMessage{
		method: method,
	}
}

type UrgencyMessage struct {
	method MessageImplementer
}

func (u *UrgencyMessage) SendMessage(text, to string) {
	u.method.Send(fmt.Sprintf("[Urgency] %s", text), to)
}
