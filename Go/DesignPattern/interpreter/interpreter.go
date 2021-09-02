/**
* @Author:zhoutao
* @Date:2020/12/12 下午3:05
* @Desc:
 */

package interpreter

import (
	"strconv"
	"strings"
)

//解释器模式：定义了一套语言文法，并设计该语言的解释器。使用户能使用特定文法-》控制解释器的行为
//解释器模式的意义在于，它分离多种复杂功能的实现，每个功能只需要关注自身的解释
//对于调用者不同关心内部的解释器的具体工作，只需要用简单的方式组合命令就可以了。

type Node interface {
	Interpret() int
}

type ValNode struct {
	val int
}

func (v *ValNode) Interpret() int {
	return v.val
}

//add
type AddNode struct {
	left, right Node
}

func (a *AddNode) Interpret() int {
	return a.left.Interpret() + a.right.Interpret()
}

//min
type MinNode struct {
	left, right Node
}

func (m *MinNode) Interpret() int {
	return m.left.Interpret() - m.right.Interpret()
}

//解析器
type Parser struct {
	exp   []string
	index int
	prev  Node
}

func (p *Parser) Parse(exp string) {
	p.exp = strings.Split(exp, " ")

	for {
		if p.index >= len(p.exp) {
			return
		}

		switch p.exp[p.index] {
		case "+":
			p.prev = p.newAddNode()
		case "_":
			p.prev = p.newMinNode()
		default:
			p.prev = p.newValNode()
		}
	}
}

func (p *Parser) newAddNode() Node {
	p.index++
	return &AddNode{
		left:  p.prev,
		right: p.newValNode(),
	}
}

func (p *Parser) newMinNode() Node {
	p.index++
	return &MinNode{
		left:  p.prev,
		right: p.newValNode(),
	}
}

func (p *Parser) newValNode() Node {
	v, _ := strconv.Atoi(p.exp[p.index])
	p.index++
	return &ValNode{
		val: v,
	}
}

func (p *Parser) Result() Node {
	return p.prev
}
