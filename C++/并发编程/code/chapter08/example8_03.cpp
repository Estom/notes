//使用std::packaged_task的std::accumulate的并行版本，来解决新线程上抛出异常的问题
template <typename Iterator,typename T>
struct accumulate_block
{
	//直接返回结果
	T operator()(Iterator first,Iterator last)
	{
		return std::accumulate(first,last,T());
	}
};

template <typename Iterator,typename T>
T parallel_accumulate(Iterator first,Iterator last,T init)
{
	unsigned long const length=std::distance(first,last);

	if(!length)
		return init;

	//2.8有讲
	unsigned long const min_per_thread=25;
	unsigned long const max_threads=(length+min_per_thread-1)/min_per_thread;

	unsigned long const hardware_threads=std::thread::hardware_concurrency();

	unsigned long const num_threads=std::min(hardware_threads!=0?hardware_threads:2,max_threads);

	unsigned long const block_size=length/num_threads;

	std::vector<std::future<T> > futures(num_threads-1);	//与8.2不同使用future变量
	std::vector<std::thread> threads(num_threads-1);

	Iterator block_start=first;
	for(unsigned long i = 0; i < (num_threads-1); ++i)
	{
		Iterator block_end=block_start;
		std::advance(block_end,block_size);
		//为accumulate_block创造一个任务
		std::packaged_task<T(Iterator,Iterator)> task(accumulate_block<Iterator,T>());
		futures[i]=task.get_future();
		threads[i]=std::thread(std::move(task),block_start,block_end);		//允许任务的时候，将在future中捕捉结果，也会捕捉任何抛出的异常
		block_start=block_end;
	}

	T last_result=accumulate_block()(block_start,last);
	std::for_each(threads.begin(),threads.end(),std::mem_fn(&std::thread::join));

	T result=init;
	for(unsigned long i=0;i<(num_threads-1);++i)
	{
		result+=futures[i].get();
	}
	result += last_result;
	return result;
}