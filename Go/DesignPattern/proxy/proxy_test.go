/**
* @Author:zhoutao
* @Date:2020/12/11 下午2:13
* @Desc:
 */

package proxy

import "testing"

var expect = "pre to do :going to do something: after to do"

func TestProxy(t *testing.T) {
	var sub Subject
	sub = &Proxy{}
	res := sub.Do()
	if res != expect {
		t.Fatalf("expect %s ,return %s", expect, res)
	}
}
