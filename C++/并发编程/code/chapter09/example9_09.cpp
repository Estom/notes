//interruptible_thread的基本实现
class interrupt_flag
{
public:
	void set();
	bool is_set() const;
};
thread_local interrupt_flag this_thread_interrupt_flag;

class interruptible_thread
{
	std::thread internal_thread;
	interrupt_flag* flag;
public:
	template <typename FunctionType>
	interrupt_thread(FunctionType f)
	{
		std::promise<interrupt_flag*> p;
		internal_thread=std::thread([f,&p]{
			p.set_value(&this_thread_interrupt_flag);
			f();
		});
	}
	void interrupt()
	{
		if(flag)
		{
			flag->set();
		}
	}
}