//为std::condition_variable_any而设的interruptible_wait
//可以与任何锁类型配合工作
class interrupt_flag
{
	std::atomic<bool> flag;
	std::condition_variable* thread_cond;
	std::condition_variable_any* thread_cond_any;
	std::mutex set_clear_mutex;

public:
	interrupt_flag():
		thread_cond(0),thread_cond_any(0)
	{}

	void set()
	{
		flag.store(true,std::memory_order_relaxed);
		std::lock_guard<std::mutex> lk(set_clear_mutex);
		if(thread_cond)
		{
			thread_cond->notify_all();
		}
		else if(thread_cond_any)
		{
			thread_cond_any->notify_all();
		}
	}

	template <typename Lockable>
	void wait(std::condition_variable_any& cv,Lockable& lk)
	{
		struct custom_lock
		{
			interrupt_flag* self;
			Lockable lk;

			custom_lock(interrupt_flag* self_,std::condition_variable_any& cond,Lockable& lk_):
				self(self_),lk(lk_)
			{
				self->set_clear_mutex.lock();
				self->thread_cond_any=&cond;
			}

			void unlock()
			{
				lk.unlock();
				self->set_clear_mutex.unlock();
			}

			void lock()
			{
				std::lock(self->set_clear_mutex,lk);
			}

			~custom_lock()
			{
				self->thread_cond_any=0;
				self->set_clear_mutex.unlock();
			}
		};
		custom_lock cl(this,cv,lk);
		interruption_point();
		cv.wait(ck);
		interruption_point();
	}
	//rest as before
};

template <typename Lockable>
void interruption_wait(std::condition_variable_any& cv,Lockable& lk)
{
	this_thread_interrupt_flag.wait(cv,lk);
}