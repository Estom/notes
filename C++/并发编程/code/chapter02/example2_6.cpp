//scoped_thread和示例用法,一旦所有权转移到该对象其他线程就不就可以动它了，保证退出一个作用域线程完成
class scoped_thread
{
	std::thread t;
public:
	explicit scoped_thread(std::thread t_):
		t(std::move(t_))
	{
		if(!t.joinable())
			throw std::logic_error("No thread");
	}
	~scoped_thread()
	{
		t.join();
	}
	scoped_thread(scoped_thread const&)=delete;
	scoped_thread& operator=(scoped_thread const&)=delete;
};

struct func;

void f()
{
	int some_local_state;
	scoped_thread t(std::thread(func(some_local_state)));

	do_something_in_current_thread();
}