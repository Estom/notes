//std::accumulate的异常安全并行版本
//使用future，最简单的方法就是捕获所有异常，并且将它们融合到调用joinable()的线程中，然后再次抛出异常。
//try-catch块令人讨厌，我们在一个对象的析构函数中检查它
class join_threads
{
	std::vector<std::thread>& threads;
public:
	explicit join_threads(std::vector<std::threads>& threads_):
		threads(threads_)
	{}
	~join_threads();
	{
		for(unsigned long i=0;i<threads.size();++i)
		{
			if(threads[i].joinable())
				threads[i].join();
		}
	}
};

template <typename Iterator,typename T>
T parallel_accumulate(Iterator first,Iterator last,T init)
{
	unsigned long const length=std::distance(first,last);

	if(!length)
		return init;

	unsigned long const min_per_thread=25;
	unsigned long const max_threads=(length+min_per_thread-1)/min_per_thread;

	unsigned long const hardware_threads=std::thread::hardware_concurrency();

	unsigned long const num_threads=std::min(hardware_threads!=0?hardware_threads:2,max_threads);

	unsigned long const block_size=length/num_threads;

	std::vector<std::future<T> > futures(num_threads-1);
	std::vector<std::thread> threads(num_threads-1);
	join_threads joiner(threads);

	Iterator block_start=first;
	for(unsigned long i=0;i<(num_threads-1);++i)
	{
		Iterator block_end=block_start;
		std::advance(block_end,block_size);
		std::packaged_task<T(Iterator,Iterator)> task(accumulate_block<Iterator,T>());
		futures[i]=task.get_future();

		threads[i]=std::thread(std::move(task),block_start,block_end);
		block_start=block_end;
	}
	T last_result=accumulate_block()(block_start,last);
	T result=init;
	for(unsigned long i=0;i<(num_threads-1);++i)
	{
		result+=futures[i].get();		//将被阻塞直到结果出来
	}
	result += last_result;
	return result;
}