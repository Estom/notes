//使用获取和释放顺序的传递性同步(利用了线程间happen-before的定义)
std::atomic<int> data[5];
std::atomic<bool> sync1(false),sync2(false);

void thread_1()
{
	data[0].store(42,std::memory_order_relaxed);
	data[1].store(97,std::memory_order_relaxed);
	data[2].store(17,std::memory_order_relaxed);
	sync1.store(true,std::memory_order_release);		//设置sync1
}

void thread_2()
{
	while(!sync1.load(std::memory_order_acquire));		//循环直到sync1被设置
	sync2.store(true,std::memory_order_release);		//设置sync2
}

void thread_3()
{
	while(!sync2.load(std::memory_order_acquire));		//循环直到sync2被设置
	assert(data[0].load(std::memory_order_relaxed)==42);
	assert(data[1].load(std::memory_order_relaxed)==97);
	assert(data[2].load(std::memory_order_relaxed)==17);
}