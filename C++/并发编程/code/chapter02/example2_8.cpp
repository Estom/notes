//使得每个线程具有最小数目的元素以避免过多的线程开销
template<typename Iterator,typename T>
struct accumulate_block
{
	void operator()(Iterator first,Iterator last,T& result)
	{
		result=std::accumlate(first,last,result);
	}
};

template<typename Iterator,typename T>
T parallel_accumlate(Iterator first,Iterator last,T init)
{
	unsigned long const length=std::distance(first,last);

	if(!length)
		return init;

	unsigned long const min_per_thread=25;
	unsigned long const max_threads=(length+min_per_thread-1)/min_per_thread;
	unsigned long const hardware_threads=std::thread::hardware_concurrency();
	unsigned long const num_threads=std::min(hardware_threads!=0?hardware_threads:2,max_threads);
	unsigned long const block_size=length/num_threads;

	std::vector<T> results(num_threads);
	std::vector<std::thread> thread(num_threads-1);

	Iterator block_start=first;
	for(unsigned long i = 0; i < (num_threads-1);++i)
	{
		Iterator block_end = block_start;
		std::advance(block_end,block_size);
		threads[i]=std::thread(accumulate_block<Iterator,T>(),block_start,block_end,std::ref(results[i]));
		block_start=block_end;
	}
	accumulate_block<Iterator,T>()(block_start,last,results[num_threads-1]);
	std::for_each(threads.begin(),threads.end(),std::mem_fn(&std::thread::join));

	return std::accumulate(results.begin(),results.end(),init);
}