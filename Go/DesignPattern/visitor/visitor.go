/**
* @Author:zhoutao
* @Date:2020/12/12 下午4:12
* @Desc:
 */

package visitor

import "fmt"

//访问者模式： 可以给一系列对象透明的添加功能，并且把相关代码封装到一个类中
//对象只要预留访问者接口Accept，则在后期为独享添加功能的时候就不需要改动对象了

type Customer interface {
	Accept(Visitor)
}

type Visitor interface {
	Visit(Customer)
}

type CustomerCol struct {
	customers []Customer
}

func (c *CustomerCol) Add(customer Customer) {
	c.customers = append(c.customers, customer)
}

func (c *CustomerCol) Accept(visitor Visitor) {
	for _, customer := range c.customers {
		customer.Accept(visitor)
	}
}

//New EnterpriseCustomer
func NewEnterpriseCustomer(name string) *EnterpriseCustomer {
	return &EnterpriseCustomer{
		name: name,
	}
}

type EnterpriseCustomer struct {
	name string
}

func (c *EnterpriseCustomer) Accept(visitor Visitor) {
	visitor.Visit(c)
}

//New IndividualCustomer
func NewIndividualCustomer(name string) *IndividualCustomer {
	return &IndividualCustomer{
		name: name,
	}
}

type IndividualCustomer struct {
	name string
}

func (i *IndividualCustomer) Accept(visitor Visitor) {
	visitor.Visit(i)
}

//
type ServiceRequestVisitor struct {
}

func (s *ServiceRequestVisitor) Visit(customer Customer) {
	switch c := customer.(type) {
	case *EnterpriseCustomer:
		fmt.Printf("serving enterprise customer %s\n", c.name)
	case *IndividualCustomer:
		fmt.Printf("serving Individual customer %s\n", c.name)
	}
}

//
type AnalisisVisitor struct {
}

func (*AnalisisVisitor) Visit(customer Customer) {
	switch c := customer.(type) {
	case *EnterpriseCustomer:
		fmt.Printf("analysis enterprise customer %s\n", c.name)
	}
}
