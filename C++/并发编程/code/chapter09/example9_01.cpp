//简单的线程池
class thread_pool
{
	std::atomic_bool done;
	thread_safe_queue<std::function<void()> > work_queue;
	std::vector<std::thread> threads;
	join_threads joiner;		//join_threads实例会保证在线程池被销毁前所有的线程已经完成

	void work_thread()
	{
		while(!done)
		{
			std::function<void()> task;
			if(work_queue.try_pop(task))
			{
				task();
			}
			else
			{
				std::this_thread::yield();
			}
		}
	}
public:
	thread_pool():
		done(false),joiner(threads)
	{
		unsigned const thread_count=std::thread::hardware_concurrency();

		try
		{
			for(unsigned i=0;i<thread_count;++i)
			{
				//创建线程来执行worker_thread()成员函数
				threads.push_back(std::thread(&thread_pool::work_thread,this));
			}
		}
		catch(...)
		{
			done=true;
			throw;
		}
	}

	~thread_pool()
	{
		done=true;
	}
	
	template <typename FunctionType>
	void submit(FunctionType f)
	{
		work_queue.push(std::function<void()>(f));
	}
};