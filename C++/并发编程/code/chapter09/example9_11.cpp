//在为std::condition_variable的interruptible_wait中使用超时
class interrupt_flag
{
	std::atomic<bool> flag;
	std::condition_variable* thread_cond;
	std::mutex set_clear_mutex;

public:
	interrupt_flag():
		thread_cond(0)
	{}

	void set()
	{
		flag.store(true,std::memory_order_relaxed);
		std::lock_guard<std::mutex> lk(set_clear_mutex);
		if(thread_cond)
		{
			thread_cond->notify_all();
		}
	}

	bool is_set() const
	{
		return flag.load(std::memory_order_relaxed);
	}

	void set_condition_variable(std::condition_variable& cv)
	{
		std::lock_guard<std::mutex> lk(set_clear_mutex);
		thread_cond=&cv;
	}

	void clear_condition_variable()
	{
		std::lock_guard<std::mutex> lk(set_clear_mutex);
		thread_cond=0;
	}

	struct clear_cv_on_destruct
	{
		~clear_cv_on_destruct()
		{
			this_thread_interrupt_flag.clear_condition_variable();
		}
	};
};

void interruptible_wait(std::condition_variable& cv,std::unique_lock<std::mutex>& lk)
{
	interruption_point();
	this_thread_interrupt_flag.set_condition_variable(cv);
	interrupt_flag::clear_cv_on_destruct guard;
	interruption_point();
	//给wait_for()传递一个很小的时间间隔(如1毫秒)而不是使用wait()
	cv.wait_for(lk,std::chrono::milliseconds(1));
	interruption_point();
}

//如果你有一个要等待的断言，那么1毫秒的超时会被完全隐藏在断言的循环中
template <typename Predicate>
void interruptible_wait(std::condition_variable& cv,std::unique_lock<std::mutex>& lk,Predicate pred)
{
	interruption_point();
	this_thread_interrupt_flag.set_condition_variable(cv);
	interrupt_flag::clear_cv_on_destruct guard;
	while(!this_thread_interrupt_flag.is_set() && !pred())
	{
		cv.wait_for(lk,std::chrono::milliseconds(1));
	}
	interruption_point();
}