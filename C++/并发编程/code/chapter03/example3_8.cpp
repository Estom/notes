//简单的分层次互斥元
class hierarchical_mutex
{
	std::mutex internal_mutex;
	unsigned long const hierarchical_value;
	unsigned long previous_hierarchical_value;
	//线程局部变量可以在程序中让你为每个线程拥有独立的变量实例，用thread_local关键字标记
	static thread_local unsigned long this_thread_hierarchical_value;

	void check_for_hierarchy_violation()
	{
		if(this_thread_hierarchical_value <= hierarchical_value)
		{
			throw std::logic_error("mutex hierarchy violated");
		}
	}
	void update_hierarchy_value()
	{
		previous_hierarchical_value = this_thread_hierarchical_value;
		this_thread_hierarchical_value = hierarchical_value;
	}
public:
	explicit hierarchical_mutex(unsigned long value):
		hierarchical_value(value),
		previous_hierarchical_value(0)
		{}
	void lock()
	{
		check_for_hierarchy_violation();
		internal_mutex.lock();
		update_hierarchy_value();
	}
	void unlock()
	{
		this_thread_hierarchical_value = previous_hierarchical_value;
		internal_mutex.unlock();
	}
	bool try_lock()
	{
		check_for_hierarchy_violation();
		if(!internal_mutex.try_lock())
			return false;
		update_hierarchy_value();
		return true;
	}
};
thread_local unsigned long
	hierarchical_mutex::this_thread_hierarchical_value(ULONG_MAX);