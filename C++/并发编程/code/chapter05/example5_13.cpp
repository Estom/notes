//在非原子操作上强制顺序
#include <atomic>
#include <thread>
#include <assert.h>

bool x=false;		//x现在是一个普通的非原子变量
std::atomic<bool> y;
std::atomic<int> z;

void write_x_then_y()
{
	x=true;			//1.在屏障前存储x
	std::atomic_thread_fence(std::memory_order_release);
	y.store(true,std::memory_order_relaxed);		//2.在屏障后存储y
}

void read_y_then_x()
{
	while(!y.load(std::memory_order_relaxed));		//等待到你看见来自2的写入
	std::atomic_thread_fence(std::memory_order_acquire);
	if(x)			//将读取1写入的值
		++z;
}

int main()
{
	x=false;
	y=false;
	z=0;
	std::thread a(write_x_then_y);
	std::thread b(read_y_then_x);
	a.join();
	b.join();
	assert(z.load()!=0);		//此断言不会触发
}