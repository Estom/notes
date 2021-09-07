//使用std::async来将参数传递给函数
#include <string>
#include <future>

struct X
{
	void foo(int,std::string const&);
	std::string bar(std::string const&);
};
X x;
auto f1=std::async(&X::foo,&x,42,"hello");		//调用p->foo(42,"hello"),其中p是&x
auto f2=std::async(&X::bar,x,"goodbye");		//调用tmpx.bar("goodbye"),其中tmpx是x的副本
struct Y
{
	double operator()(double);
};
Y y;
auto f3=std::async(Y(),3.141);					//调用tmpy(3.131),其中tm
auto f4=std::async(std::ref(y),2.718);			//调用y(2.718),
X baz(X&);
std::async(baz,std::ref(x));					//调用baz(x)
class move_only
{
public:
	move_only();
	move_only(move_only&&);
	move_only(move_only const&) = delete;
	move_only& operator=(move_only&&);
	move_only& operator=(move_only const&) = delete;
	void operator()();
};//这个类将拷贝构造函数和赋值构造函数都取消了，只留下移动构造函数
auto f5=std::async(move_only());				//调用tmp(),其中tmp是从std::move(move_only())构造的