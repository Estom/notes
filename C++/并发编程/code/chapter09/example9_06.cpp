//使用本地线程工作队列的线程池来避免工作队列上的竞争
class thread_pool
{
	thread_safe_queue<function_wrapper> pool_work_queue;
	typedef std::queue<function_wrapper> local_queue_type;
	//使用thread_local变量来保证每个线程有一个自己的工作队列再加上一个全局的工作队列。
	//使用unique_ptr<>来保存线程私有的工作队列因为我们不想让非线程池中的线程也持有一个
	static thread_local std::unique_ptr<local_queue_type> local_work_queue;

	void worker_thread()
	{
		local_work_queue.reset(new local_queue_type)

		while(!done)
		{
			run_pending_task();
		}
	}

public:
	template <typename FunctionType>
	std::future<typename std::result_of<FunctionType()>::type>
		submit(FunctionType f)
	{
		typedef typename std::result_of<FunctionType()>::type result_type;

		std::packaged_task<result_type()> task(f);
		std::future<result_type> res(task.get_future());
		if(local_work_queue)		//submit()函数会检查当前线程是否有一个工作队列。
		{
			local_work_queue->push(std::move(task));	//如果有当前线程时一个线程池中线程，添加私有工作队列，
		}
		else
		{
			pool_work_queue.push(std::move(task));		//将任务添加到全局工作队列中
		}
		return res;
	}

	void run_pending_task()
	{
		function_wrapper task;
		if(local_work_queue && !local_queue_type->empty())
		{
			task=std::move(local_work_queue->front());
			local_work_queue->pop();
			task();
		}
		else if(pool_work_queue.try_pop(task))
		{
			task();
		}
		else
		{
			std::this_thread::yield();
		}
	}
	//rest as before
};