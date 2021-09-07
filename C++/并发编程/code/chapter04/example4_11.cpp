//等待一个具有超时的条件变量
#include <condition_variable>
#include <mutex>
#include <chrono>
std::condition_variable cv;
bool done;
std::mutex m;

bool wait_loop()
{
	auto const timeout=std::chrono::steady_clock::now()+std::chrono::milliseconds(500);
	std::unique_lock<std::mutex> lk(m);
	while(!done)
	{
		if(cv.wait_until(lk,timeout)==std::cv_status::timeout)
			break;
	}
	return done;
}