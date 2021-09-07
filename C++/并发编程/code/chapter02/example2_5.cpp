//从函数中返回std::thread,控制权从函数中转移出
std::thread f()
{
	void some_function();
	return std::thread(some_function);
}
std::thread g()
{
	void some_other_function(int);
	std::thread t(some_other_function,42);
	return t;
}

//控制权从函数中转移进
void f(std::thread t);
void g()
{
	void some_function();
	f(std::thread(some_function));
	std::thread t(some_function);
	f(std::move(t));
}