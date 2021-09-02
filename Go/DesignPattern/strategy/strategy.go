/**
* @Author:zhoutao
* @Date:2020/12/12 下午1:50
* @Desc:
 */

package strategy

import "fmt"

//策略模式：定义一系列算法，让这些算法在运行时可以互换，使得算法分离，符合开闭原则

type PaymentContext struct {
	Name, CardID string
	Money        int
}

func NewPayment(name, cardID string, money int, strategy PaymentStrategy) *Payment {
	return &Payment{
		context: &PaymentContext{
			Name:   name,
			CardID: cardID,
			Money:  money,
		},
		strategy: strategy,
	}
}

type Payment struct {
	context  *PaymentContext
	strategy PaymentStrategy
}

func (p *Payment) Pay() {
	p.strategy.Pay(p.context)
}

type PaymentStrategy interface {
	Pay(*PaymentContext)
}

//by cash
type Cash struct {
}

func (*Cash) Pay(ctx *PaymentContext) {
	fmt.Printf("Pay $%d to %s by cash", ctx.Money, ctx.Name)
}

//by Bank
type Bank struct {
}

func (*Bank) Pay(ctx *PaymentContext) {
	fmt.Printf("Pay $%d to %s by Bank", ctx.Money, ctx.Name)
}
