//队列上当前调用的push()和pop()的测试例子
void test_concurrent_push_and_pop_on_empty_queue()
{
	threadsafe_queue<int> q;			//首先，创建空队列，这部分作为通用启动代码

	std::promise<void> go,push_ready,pop_ready;			//然后，为所有“就绪”信号创建各自的Promise
	std::shared_future<void> ready(go.get_future());	//并为go信号获取一个std::shared_future

	std::future<void> push_done;						//创建future来表示线程已经运行结束
	std::future<int> pop_done;
	//为一场设置go信号二无需等待测试结束，(这是为了将死锁限制在测试代码内部)
	try
	{
		push_done=std::async(std::launch::async,
							[&q,ready,&push_ready]()
							{
								push_ready.set_value();
								ready.wait();
								q.push(42);
							});
		pop_done=std::async(std::launch::async,
							[&q,ready,&pop_ready]()
							{
								pop_ready.set_value();
								ready.wait();
								return q.pop();
							});
		//上面启动线程，
		push_ready.get_future().wait();
		pop_ready.get_future().wait();
		go.set_value();

		push_done.get();
		assert(pop_done.get()==42);
		assert(q.empty());
	}
	catch(...)
	{
		go.set_value();		//你设置go信号来避免任何产生悬挂线程和再次抛出异常的机会	
		throw;
	}
}