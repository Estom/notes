package facade

import "fmt"

//外观模式:随着项目越来越大，代码之间可能会有一些顺序，如果把他们封装起来，
//那么对于调用者而言，
//就只需要调用一个函数 ,而并不需要知道这个函数里面具体做了什么，有什么依赖顺序

//隐藏了内部实现，调用者只需要调用一个函数
//New apiImpl
func NewAPI() API {
	return &apiImpl{
		a: NewAmoudleAPI(),
		b: NewBMoudleAPI(),
	}
}

//API是一个外观模式 接口
type API interface {
	Test() string
}

//外观模式实现
type apiImpl struct {
	a AMouduleAPI
	b BMouduleAPI
}

func (a *apiImpl) Test() string {
	aRet := a.a.TestA()
	bRet := a.b.TestB()
	return fmt.Sprintf("%s\n%s", aRet, bRet)
}

//New aMoudleImpl
func NewAmoudleAPI() AMouduleAPI {
	return &aMouduleImpl{}
}

//AMouduleAPI
type AMouduleAPI interface {
	TestA() string
}
type aMouduleImpl struct{}

func (*aMouduleImpl) TestA() string {
	return "A moudle running"
}

//New bMoudleImpl
func NewBMoudleAPI() BMouduleAPI {
	return &bMoudleImpl{}
}

//BMouduleAPI
type BMouduleAPI interface {
	TestB() string
}
type bMoudleImpl struct{}

func (*bMoudleImpl) TestB() string {
	return "B module running"
}
