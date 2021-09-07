//std::accumulate的并行版本(来自清单2.8)
template <typename Iterator,typename T>
struct accumulate_block
{
	void operator()(Iterator first,Iterator last,T& result)
	{
		result=std::accumulate(first,last,result);
	}
};

template <typename Iterator,typename T>
T parallel_accumulate(Iterator first,Iterator last,T init)
{
	unsigned long const length=std::distance(first,last);

	if(!length)				//如果输入的范围为空，只返回初始值init
		return init;

	unsigned long const min_per_thread=25;		//最小块的大小
	unsigned long const max_threads=(length+min_per_thread-1)/min_per_thread;	//处理的元素数量除以最小块的大小，获取线程的最大数量

	unsigned long const hardware_threads=std::thread::hardware_concurrency();	//真正并发运行的线程数量的指示
	//要运行的线程数是你计算出的最大值的硬件线程数量的较小值。
	unsigned long const num_threads=std::min(hardware_threads!=0?hardware_threads:2,max_threads);
	//如果hardware_concurrency返回0，我们就替换成2，运行过多的线程，会在单核机器上变慢，过少会错过可用的并发
	
	unsigned long const block_size=length/num_threads;	//待处理的线程的条目数量是范围的长度除以线程的数量

	std::vector<T> results(num_threads);				//保存中间结果
	std::vector<std::thread> threads(num_threads-1);	//因为有一个线程（本线程）了所以少创建一个文档

	//循环：1.递进block_end到当前块的结尾，2.并启动一个新的线程来累计此块的结果。3.下一个块的开始是这一个的结束
	Iterator block_start=first;
	for(unsigned long i = 0; i < (num_threads-1);++i)
	{
		Iterator block_end=block_start;
		std::advance(block_end,block_size);	...1
		threads[i]=std::thread(accumulate_block<Iterator,T>(),block_start,block_end,std::ref(results[i]));	...2
		block_start=block_end;	...3
	}

	//这里是处理上面没有整除的掉block_size的剩下的部分
	accumulate_block()(block_start,last,results[num_threads-1]);
	//通过join等待所有计算的线程
	std::for_each(threads.begin(),threads.end(),std::mem_fn(&std::thread::join));
	//一旦累计计算出最后一个块的结果，调用accumulate将结果计算出来
	return std::accumulate(results.begin(),results.end(),init);
}
