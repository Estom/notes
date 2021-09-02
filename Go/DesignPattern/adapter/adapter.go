package adapter

//适配器模式
//应用最多的是在接口升级，而又需要保证老接口的兼容性，为了让老接口能够继续工作，所以提供了一个中间层，让老接口对外的接口不变
//但是实际上调用了新的代码

//被适配接口的工厂函数
func NewAdaptee() Adaptee {
	return &adapteeImpl{}
}

//被适配的目标接口
type Adaptee interface {
	SpecificRequest() string
}

type adapteeImpl struct {
}

func (*adapteeImpl) SpecificRequest() string {
	return "adaptee method被适配器方法"
}

func NewAdapter(adaptee Adaptee) Target {
	return &adapter{
		Adaptee: adaptee,
	}
}

//Target是适配的目标接口
type Target interface {
	Request() string
}

type adapter struct {
	Adaptee
}

func (a *adapter) Request() string {
	return a.SpecificRequest()
}
