#include <iostream>
#include <thread>
//join的作用是让主线程等待直到该子线程执行结束，示例：
//需要注意的是线程对象执行了join后就不再joinable了，所以只能调用join一次。

void hello()
{
	std::cout<<"Hello Concurrent World\n";
}

int main()
{
	std::thread t(hello);
	t.join();
}