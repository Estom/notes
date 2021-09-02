/**
* @Author:zhoutao
* @Date:2020/12/12 上午10:16
* @Desc:
 */

package mediator

import "testing"

//中介模式
func TestMediator(t *testing.T) {
	mediator := GetMediatorInstance()
	mediator.CD = &CDDriver{}
	mediator.Video = &VideoCard{}
	mediator.Sound = &SoundCard{}
	mediator.CPU = &CPU{}

	//run
	mediator.CD.ReadData()

	if mediator.CD.Data != "music,image" {
		t.Fatalf("CD unexpect data %s", mediator.CD.Data)
	}
	if mediator.CPU.Sound != "music" {
		t.Fatalf("CPU unexpect data %s", mediator.CPU.Sound)
	}
	if mediator.CPU.Video != "image" {
		t.Fatalf("CPU unexpect data data %s", mediator.CPU.Video)
	}
	if mediator.Video.Data != "image" {
		t.Fatalf("VidelCard unexpect data %s", mediator.Video.Data)
	}
	if mediator.Sound.Data != "music" {
		t.Fatalf("SoundCard unexpect data %s", mediator.Sound.Data)
	}
}
