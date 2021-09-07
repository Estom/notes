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

void oops()
{
	int some_local_state = 0;
	func my_function(some_local_state);
	std::thread my_thread(my_func);
	my_thread.detach();		//不等待线程完成
}							//新的线程可能仍在运行