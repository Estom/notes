//std::for_each的并行版本
template <typename Iterator,typename Func>
void parallel_for_each(Iterator first,Iterator last,Func f)
{
	unsigned long const length=std::distance(first,last);

	if(!length)
		return;

	unsigned long const min_per_thread=25;
	unsigned long const max_threads=(length+min_per_thread-1)/min_per_thread;

	unsigned long const hardware_threads=std::thread::hardware_concurrency();

	unsigned long const num_threads=std::min(hardware_threads!=0?hardware_threads:2,max_threads);

	unsigned long const block_size=length/num_threads;

	std::vector<std::future<void> > futures(num_threads-1);
	std::vector<std::thread> threads(num_threads-1);
	join_threads joiner(threads);

	Iterator block_start=first;
	for(unsigned long i=0; i<(num_threads-1);++i)
	{
		Iterator block_end=block_start;
		std::advance(block_end,block_size);
		std::packaged_task<void(void)> task([=](){
			std::for_each(block_start,block_end,f);
		});
		futures[i]=task.get_future();
		threads[i]=std::thread(std::move(task));
		block_start=block_end;
	}
	std::for_each(block_start,last,f);
	for (unsigned long i = 0; i < (num_threads-1); ++i)
	{
		//只提供取回工作线程抛出的异常的方法，如果你不希望传递异常，那么你就可以省略它。
		futures[i].get();
	}
}