//使用std::packaged_task在GUI线程上运行代码
#include <deque>
#include <mutex>
#include <future>
#include <thread>
#include <utility>			//这里有move函数

std::mutex m;
std::deque<std::packaged_task<void()> > tasks;

bool gui_shutdown_message_received();
void get_and_process_gui_message();

void gui_thread()
{
	while(!gui_shutdown_message_received())
	{
		get_and_process_gui_message();
		std::packaged_task<void()> task;
		{
			std::lock_guard<std::mutex> lk(m);
			if(tasks.empty())
				continue;
			task=std::move(tasks.front());		//move将对象的状态或对象转移到另一个对象，原来那个对象就为空了。
			tasks.pop_front();
		}
		task();
	}
}

std::thread gui_bg_thread(gui_thread);

template <typename Func>
std::future<void> post_task_for_gui_thread(Func f)
{
	std::packaged_task<void()> task(f);
	std::future<void> res=task.get_future();
	std::lock_guard<std::mutex> lk(m);
	tasks.push_back(std::move(task));
	return res;
}