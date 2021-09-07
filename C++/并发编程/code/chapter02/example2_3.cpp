//使用RAII等待线程完成
class thread_guard
{
	std::thread& t;
public:
	explicit thread_guard(std::thread& t_):
		t(t_)
	{}
	~thread_guard()
	{
		if(t.joinable())
		{
			t.join();
		}
	}
	thread_guard(thread_guard const&)=delete;
	thread_guard& operator=(thread_guard const&)=delete;
};

struct func;	//2_1

void f()
{
	int some_local_state = 0;
	func my_func(some_local_state);
	std::thread t(my_func);
	thread_guard g(t);

	do_something_in_current_thread();
}	//在当前线程的执行到达f末尾时，局部对象会按照构造函数的逆序被销毁，因此，thread_guard对象g首先被销毁。
