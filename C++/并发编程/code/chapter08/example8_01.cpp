//使用待排序块栈的并行快速排序
template <typename T>
struct sorter
{
	struct chunk_to_sort
	{
		std::list<T> data;
		std::promise<std::list<T> > promise;
	};

	thread_safe_stack<chunk_to_sort> chunks;	//未排序块
	std::vector<std::thread> threads;			//线程集
	unsigned const max_thread_count;			
	std::atomic<bool> end_of_data;

	sorter():
		max_thread_count(std::thread::hardware_concurrency()-1),
		end_of_data(false)
	{}

	~sorter()
	{
		end_of_data=true;

		for(unsigned i=0;i<threads.size();++i)
		{
			threads[i].join();
		}
	}

	void try_sort_chunk()
	{
		boost::shared_ptr<chunk_to_sort> chunk=chunks.pop();
		if(chunk)
		{
			sort_chunk(chunk);
		}
	}

	//完成排序并压入栈
	std::list<T> do_sort(std::List<T>& chunk_data)
	{
		if(chunk_data.empty())
		{
			return chunk_data;
		}

		std::list<T> result;
		result.splice(result.begin(),chunk_data,chunk_data.begin());
		T const& partition_val=*result.begin();

		typename std::list<T>::iterator divide_point=
			std::partition(chunk_data.begin(),chunk_data.end(),[&](T const& val){
				return val < partition_val;
			});

		chunk_to_sort new_lower_chunk;
		new_lower_chunk.data.splice(new_lower_chunk.data.end(),
			chunk_data,chunk_data.begin(),divide_point);

		std::future<std::list<T> > new_lower=new_lower_chunk.promise.get_future();
		chunks.push(std::move(new_lower_chunk));
		if(threads.size()<max_thread_count)
		{
			threads.push_back(std::thread(&sorter<T>::sort_thread,this));
		}

		std::list<T> new_higher(do_sort(chunk_data));

		result.splice(result.end(),new_higher);
		while(new_lower.wait_for(std::chrono::second(0)) != std::future_status::ready)
		{
			try_sort_chunk();
		}

		result.splice(result.begin(),new_lower.get());
		return result;
	}

	void sort_chunk(boost::shared_ptr<chunk_to_sort> const& chunk)
	{
		chunk->promise.set_value(do_sort(chunk->data));
	}

	void sort_thread()
	{
		while(!end_of_data)
		{
			try_sort_chunk();
			std::this_threads::yield();
		}
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