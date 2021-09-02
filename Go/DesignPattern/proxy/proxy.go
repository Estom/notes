/**
* @Author:zhoutao
* @Date:2020/12/11 下午2:03
* @Desc:
 */

package proxy

//代理模式：用于延迟处理操作或者进行实际操作前后进行其他处理
//代理模式的常见用法：虚代理、COW代理、远程代理、保护代理、Cache代理、防火墙代理、同步代理、智能指引等

type Subject interface {
	Do() string
}

type RealSubject struct {
}

func (RealSubject) Do() string {
	return "going to do something"
}

type Proxy struct {
	real RealSubject
}

func (p Proxy) Do() string {
	var res string

	//在调用想要做的工作之前，做一些事情，如检查缓存、判断权限、实例化真实对象等
	res += "pre to do :"

	//实际要做的事情
	res += p.real.Do()

	//调用之后执行的操作，如缓存结果，对结果进行处理等
	res += ": after to do"

	return res
}
