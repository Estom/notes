/**
* @Author:zhoutao
* @Date:2020/12/13 上午11:31
* @Desc:
 */

package buidler

import "testing"

func TestBuilder1(t *testing.T) {
	builder := &Builder1{}
	director := NewDirector(builder)
	director.Construct()
	res := builder.GetResult()
	if res != "123" {
		t.Fatalf("Builder1 fail expect 123 ,return %s", res)
	}

}

func TestBuilder2(t *testing.T) {
	builder := &Builder2{}
	director := NewDirector(builder)
	director.Construct()
	res := builder.GetResult()
	if res != 6 {
		t.Fatalf("Buidler2 fail expect 6,return %d", res)
	}
}
