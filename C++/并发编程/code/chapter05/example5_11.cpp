//使用原子操作从队列中读取值
#include <atomic>
#include <thread>

std::vector<int> queue_data;
std::atomic<atomic> count;

void populate_queue()
{
	unsigned const number_of_items=20;
	queue_data.clear();
	for (unsigned i = 0; i < number_of_items; ++i)
	{
		queue_data.push_back(i);
	}

	count.store(number_of_items,std::memory_order_release);		//最初的存储
}

void consume_queue_items()
{
	while(true)
	{
		int item_index;
		//fetch_sub()是一个具有memory_order_acquire语义的读取，并且存储具有memory_order_release语义，所以存储与载入同步
		if((item_index=count.fetch_sub(1,std::memory_order_acquire))<=0)	//一个读-修改-写操作
		{
			wait_for_more_items();		//等待更多的项目
			continue;
		}
		process(queue_data[item_index-1]);		//读取queue_data是安全的
	}
}

int main()
{
	std::thread a(populate_queue);
	std::thread b(consume_queue_items);
	std::thread c(consume_queue_items);
	a.join();
	b.join();
	c.join();
}