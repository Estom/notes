/**
* @Author:zhoutao
* @Date:2020/12/12 下午3:46
* @Desc:
 */

package chain

import "fmt"

//责任链模式：用于分离不同职责，并且动态组合相关职责
//golang因为没有继承的支持，在实现责任链的时候，使用链对象 涵盖 职责的方式，
//即：
//1、链对象包含当前职责对象以及下一个职责链
//2、职责对象提供接口表示 是否能处理对应请求
//3、职责对象提供处理函数的相关职责
// 同时在职责链类中实现职责接口相关函数，使职责链对象可以当做一般职责对象使用

type Manager interface {
	HaveRight(money int) bool
	HandleFeeRequest(name string, money int) bool
}

//
type RequestChain struct {
	Manager
	successor *RequestChain
}

//connected r Chain with m Chain
func (r *RequestChain) SetSuccessor(m *RequestChain) {
	r.successor = m
}

func (r *RequestChain) HandleFeeRequest(name string, money int) bool {
	if r.Manager.HaveRight(money) {
		return r.Manager.HandleFeeRequest(name, money)
	}
	if r.successor != nil {
		return r.successor.HandleFeeRequest(name, money)
	}
	return false
}

func (r *RequestChain) HaveRight(money int) bool {
	return true
}

//new chain by projectManager
//职责：ProjectManager
func NewProjectManagerChain() *RequestChain {
	return &RequestChain{
		Manager: &ProjectManager{},
	}
}

type ProjectManager struct {
}

func (p *ProjectManager) HaveRight(money int) bool {
	return money < 50
}

func (p *ProjectManager) HandleFeeRequest(name string, money int) bool {
	if name == "bob" {
		fmt.Printf("Project manager permit %s %d fee request\n", name, money)
		return true
	}
	fmt.Printf("Project manager do not permit %s fee request\n", name, money)
	return false
}

//new chain by DepManager
//职责：DepManager
func NewDepManagerChain() *RequestChain {
	return &RequestChain{
		Manager: &DepManager{},
	}
}

type DepManager struct {
}

func (d *DepManager) HaveRight(money int) bool {
	return money < 5000
}

func (d *DepManager) HandleFeeRequest(name string, money int) bool {
	if name == "bob" {
		fmt.Printf("dep manager permit %s %d fee request\n", name, money)
		return true
	}
	fmt.Printf("dep manager do not permit %s fee request\n", name, money)
	return false
}

//new chain by GeneralManager
//职责：GeneralManager
func NewGeneralManagerChain() *RequestChain {
	return &RequestChain{
		Manager: &GeneralManager{},
	}
}

type GeneralManager struct {
}

func (g *GeneralManager) HaveRight(money int) bool {
	return true
}

func (g *GeneralManager) HandleFeeRequest(name string, money int) bool {
	if name == "bob" {
		fmt.Printf("general manager permit %s %d fee request\n", name, money)
		return true
	}
	fmt.Printf("general manager do not permit %s fee request\n", name, money)
	return false
}
