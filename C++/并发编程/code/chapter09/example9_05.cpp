//基于线程池的快速排序的实现
template <typename T>
struct sorter
{
	thread_pool pool;

	std::list<T> do_sort(std::list<T>& chunk_data)
	{
		if(chunk_data.empty())
		{
			return chunk_data;
		}

		std::list<T> result;
		result.splice(result.begin(),chunk_data,chunk_data.begin());
		T const& partition_val=*result.begin();

		typename std::list<T>::iterator divide_point=
			std::partition(chunk_data.begin(),chunk_data.end(),[&](T const& val){return val<partition_val;});

		//向线程池提交一个任务
		std::future<std::lost<T> > new_lower=pool.submit(std::bind(&sorter::do_sort,this,std::move(new_lower_chunk)));

		std::list<T> new_higher(do_sort(chunk_data));

		result.splice(result.end(),new_higher);
		while(!new_lower.wait_for(std::chrono::seconds(0)) == std::future_state::timeout)
		{
			//执行正在等待的任务
			pool.run_pending_task();
		}

		result.splice(result.begin(),new_lower.get());
		return result;
	}
};

template <typename T>
std::list<T> parallel_quick_sort(std::list<T> input)
{
	if(input.empty())
	{
		return input;
	}
	sorter<T> s;

	return s.do_sort(input);
}
