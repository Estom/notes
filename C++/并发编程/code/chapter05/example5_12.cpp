//松散操作可以使用屏障来排序
#include <atomic>
#include <thread>
#include <assert.h>

std::atomic<bool> x,y;
std::atomic<int> z;

void write_x_then_y()
{
	x.store(true,std::memory_order_relaxed);
	std::atomic_thread_fence(std::memory_order_release);		//释放屏障
	y.store(true,std::memory_order_relaxed);
}

void read_y_then_x()
{
	while(!y.load(std::memory_order_relaxed));
	std::atomic_thread_fence(std::memory_order_acquire);		//获取屏障
	//对x的存储发生在从x的载入之前，所以读取的值必然是true
	if(x.load(std::memory_order_relaxed))
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
	assert(z.load()!=0);
}