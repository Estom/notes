//实现不使用锁的线程安全push()
template <typename T>
class lock_free_stack
{
private:
	struct node
	{
		T data;
		node* next;

		node(T const& data_):
			data(data_)
		{}
	};
public:
	void push(T const& data)
	{
		node* const new_node=new node(data);
		new_node->next=head.load();
		while(!head.compare_exchange_weak(new_node->next,new_node));
		//如果这两个值是一样的，那么将head指向new_node。这段代码中使用了比较/交换函数的一部分，
		//如果它返回false则表明此次比较没有成功(例如，因为另一个线程修改了head)。此时，第一个参数(new_node->next)的值
		//将被更新为head当前的值。
	}
};
