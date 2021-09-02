package proto

//原型模式：使对象能复制自身，并暴露到接口中，使客户端面向接口编程时，不知道接口实际对象的情况下可以生成新的对象
//原型模式配合管理器使用，通过接口管理器可以在客户端不知道具体类型的情况下，得到新的实例，并且包含部分预设的配置

type Cloneable interface {
	Clone() Cloneable
}

//
func NewProtoManager() *ProtoManager {
	return &ProtoManager{
		protos: make(map[string]Cloneable),
	}
}

type ProtoManager struct {
	protos map[string]Cloneable
}

func (p *ProtoManager) Get(name string) Cloneable {
	return p.protos[name]
}

func (p *ProtoManager) Set(name string, proto Cloneable) {
	p.protos[name] = proto
}
