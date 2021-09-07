//一个函数调用的参数的估计顺序是未指定的
#include <iostream>

void foo(int a,int b)
{
	std::cout<<a<<","<<b<<std::endl;
}

int get_num()
{
	static int i = 0;
	return ++i;
}

int main()
{
	foo(get_num(),get_num());		//对get_num()的调用是无序的
}