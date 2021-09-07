//一个简单的spawn_task的实现
//相比于使用std::async，只有在你确实知道将要做什么，并且希望想要通过线程池建立的方式进行完全掌控和执行任务的时候，
//才值得首选这种方法
template <typename F,typename A>
std::future<std::result_of<F(A&&)>::type> spawn_task(F&& f,A&& a)
{
	typedef std::result_of<F(A&&)>::type result_type;
	std::packaged_task<result_type> res(task.get_future());
	std::thread t(std::move(task),std::move(a));
	t.detach();
	return res;
}