/**
* @Author:zhoutao
* @Date:2020/12/12 下午4:14
* @Desc:
 */

package single

import "sync"

//单例模式：使用懒惰模式的单例模式，使用双重检查加锁保证线程安全

type Singleton struct {
}

var singelton *Singleton
var once sync.Once

func GetInstance() *Singleton {
	once.Do(func() {
		singelton = &Singleton{}
	})
	return singelton
}
