struct func
{
	int& i;
	func(int& i_):i(i_) {}
	void operator() ()
	{
		for(unsigned j = 0; j < 1000000; ++j)
		{
			do_something(i);	//对悬空引用可能的访问
		}
	}
};

void f()
{
	int some_local_state = 0;
	func my_func(some_local_state);
	std::thread t(my_func);
	try
	{
		do_something_in_current_thread();
	}
	catch(...)
	{
		t.join;		//异常中断，局部函数的线程在函数退出前结束
		throw;
	}
	t.join;		//正常结束，局部函数的线程在函数退出前结束
}