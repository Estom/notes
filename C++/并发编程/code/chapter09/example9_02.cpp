//有等待任务的线程池
//因为std::packaged_task<>的实例只是可移动的，不是可复制的，不能够用std::function<>来作为队列中的元素，
//因为std::function<>要求存储的函数对象是可以拷贝和构造的。所以需要function_wrapper
class function_wrapper
{
	struct impl_base
	{
		virtual void call()=0;
		virtual ~impl_base() {}
	};
	std::unique_ptr<impl_base> impl;
	template <typename F>
	struct impl_type: impl_base
	{
		F f;
		impl_type(F&& f_): f(std::move(f_)) {}
		void call() { f(); }
	};
public:
	template <typename F>
	function_wrapper(F&& f):
		impl(new impl_type<F>(std::move(f)))
	{}

	void operator()(){ impl->call(); }

	function_wrapper()=default;

	function_wrapper(function_wrapper&& other):
		impl(std::move(other.impl))
	{}
	function_wrapper& operator=(function_wrapper&& other)
	{
		impl=std::move(other.impl);
		return* this;
	}

	function_wrapper(const function_wrapper&)=delete;
	function_wrapper(function_wrapper&)=delete;
	function_wrapper& operator=(const function_wrapper&)=delete;
};

class thread_pool
{
	thrad_safe_queue<function_wrapper> work_queue;		//使用函数包装器而非std::function

	void worker_thread()
	{
		while(!done)
		{
			function_wrapper task;
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
	template <typename FunctionType>
	//返回一个std::future<>对象来保存任务的返回值和允许调用者等待任务结束
	std::future<typename std::result_of<FunctionType()>::type>		
		submit(FunctionType f)	
	{
		 typedef typename std::result_of<FunctionType()>::type result_type;

		 std::packaged_task<result_type()> task(std::move(f));
		 std::future<result_type> res(task.get_future());
		 work_queue.push(std::move(task));
		 retrun res;
	}
	//rest as before
};