//意外的传出对受保护数据的引用
class some_data
{
	int a;
	std::string b;
public:
	void do_something();
};

class data_warpper
{
private:
	some_data data;
	std::mutex m;
public:
	template<typename Function>
	void process_data(Function func)
	{
		std::lock_guard<std::mutex> l(m);
		func(data);				//传递“受保护的”数据到用户提供的函数
	}
};
some_data* unprotected;

void malicious_function(some_data& protected_data)
{
	unprotected = &protected_data;
}

data_warpper x;

void foo()
{
	x.protected_data(malicious_function);	//传入一个恶意函数
	unprotected->do_something();			//对受保护的数据进行未受保护的访问
}