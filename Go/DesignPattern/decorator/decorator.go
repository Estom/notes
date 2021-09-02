package decorator

//装饰模式：使用对象组合的方式，动态改变或增加对象行为

type Component interface {
	Calc() int
}

type ConcreteComponent struct{}

func (*ConcreteComponent) Calc() int {
	return 0
}

//warp mul
func WarpMulDecorator(c Component, num int) Component {
	return &MulDecorator{
		Component: c,
		num:       num,
	}
}

type MulDecorator struct {
	Component
	num int
}

func (m *MulDecorator) Calc() int {
	return m.Component.Calc() * m.num
}

func WarpAddDecrator(c Component, num int) Component {
	return &AddDecrator{
		Component: c,
		num:       num,
	}
}

type AddDecrator struct {
	Component
	num int
}

func (d *AddDecrator) Calc() int {
	return d.Component.Calc() + d.num
}
