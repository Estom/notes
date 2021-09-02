package composite

import "fmt"

//组合模式：统一对象和对象集，使得使用相同接口操作对象和对象集
//组合模式常用于树状结构，用于统一叶子节点和树节点的访问，并且可以用于应用某一操作到所有子节点

type Component interface {
	Parent() Component
	SetParent(Component)
	Name() string
	SetName(string)
	AddChild(Component)
	Print(string)
}

const (
	LeafNode = iota
	CompositeNode
)

//new Component
func NewComponent(kind int, name string) Component {
	var c Component
	switch kind {
	case LeafNode:
		c = NewLeaf()
	case CompositeNode:
		c = NewComposite()
	}
	c.SetName(name)
	return c
}

//component 树节点
type component struct {
	parent Component
	name   string
}

func (c *component) Parent() Component {
	return c.parent
}
func (c *component) SetParent(parent Component) {
	c.parent = parent
}
func (c *component) Name() string {
	return c.name
}
func (c *component) SetName(name string) {
	c.name = name
}
func (c *component) AddChild(Component) {}
func (c *component) Print(string) {
}

//new leaf
func NewLeaf() *Leaf {
	return &Leaf{}
}

//叶子节点
type Leaf struct {
	component
}

func (c *Leaf) Print(pre string) {
	fmt.Printf("%s-%s\n", pre, c.name)
}

// new 组合
func NewComposite() *Composite {
	return &Composite{
		childs: make([]Component, 0),
	}
}

//组合
type Composite struct {
	component
	childs []Component
}

func (c *Composite) AddChild(child Component) {
	child.SetParent(c)
	c.childs = append(c.childs, child)
}

func (c *Composite) Print(pre string) {
	fmt.Printf("%s+%s\n", pre, c.Name())
	pre += " "
	for _, comp := range c.childs {
		comp.Print(pre)
	}
}
