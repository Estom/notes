//使用std::memory_order_consume同步数据，用于在原子操作载入指向某数据的指针的场合
struct X
{
	int i;
	std::string s;
};

std::atomic<X*> p;
std::atomic<int> a;

void create_x()
{
	X* x=new X;
	x->i=42;
	x->s="hello";
	a.store(99,std::memory_order_relaxed);		
	p.store(x,std::memory_order_release);
}

void use_x()
{
	X* x;
	while(!(x=p.load(std::memory_order_consume)))				//对p的存储只发生在依赖p的载入值得表达式之前
		std::this_thread::sleep(std::chrono::microseconds(1));
	assert(x->i==42);
	assert(x->s=="hello");
	assert(a.load(std::memory_order_relaxed)==99);
}

int main()
{
	std::thread t1(create_x);
	std::thread t2(use_x);
	t1.join();
	t2.join();
}