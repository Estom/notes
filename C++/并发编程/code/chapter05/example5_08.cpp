//获取-释放操作可以在松散操作中施加顺序
#include <atomic>
#include <thread>
#include <assert.h>

std::atomic<bool> x,y;
std::atomic<int> z;

void write_x_then_y()
{
	//对x的存储发生在对y的存储之前，因为他们在同一个线程
	x.store(true,std::memory_order_relaxed);	//旋转，等待y被设为true
	//relaxed松散顺序，release获得-释放顺序
	y.store(true,std::memory_order_release);
}

void read_y_then_x()
{
	//对y的加载将会看到由存储写下的true。因为存储使用memory_order_release并且载入
	//使用memory_order_acquire,存储与载入同步。
	while(!y.load(std::memory_order_aquire));
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