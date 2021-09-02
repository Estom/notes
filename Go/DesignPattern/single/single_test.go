/**
* @Author:zhoutao
* @Date:2020/12/13 上午10:48
* @Desc:
 */

package single

import (
	"sync"
	"testing"
)

const parCount = 100

func TestSingleton(t *testing.T) {
	ins1 := GetInstance()
	ins2 := GetInstance()
	if ins1 != ins2 {
		t.Fatal("instance is not equal")
	}
}

func TestParalleSingleton(t *testing.T) {
	start := make(chan struct{})
	wg := sync.WaitGroup{}
	wg.Add(parCount)
	instances := [parCount]*Singleton{}
	for i := 0; i < parCount; i++ {
		go func(index int) {
			//等待channel的关闭信号
			<-start
			instances[index] = GetInstance()
			wg.Done()
		}(i)
	}
	//关闭channel，发送关闭信号
	close(start)
	wg.Wait()
	for i := 1; i < parCount; i++ {
		if instances[i] != instances[i-1] {
			t.Fatal("instance is not equal")
		}
	}
}
