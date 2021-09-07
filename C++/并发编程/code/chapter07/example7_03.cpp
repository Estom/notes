//缺少结点的无锁栈
template <typename T>
class lock_free_stack
{
private:
	struct node
	{
		std::shared_ptr<T> data;		//data现在由指针持有
		node* next;

		node(T const& data_):
			data(std::make_shared<T>(data_))		//为新分配的T创建std::shared_ptr
		{}
	};

	std::atomic<node*> head;
public:
	void push(T const& data)
	{
		node* const new_node=new node(data);
		new_node->next=head.load();
		while(!head.compare_exchange_weak(new_node->next,new_node));
	}
	std::shared_ptr<T> pop()
	{
		node* old_head=head.load();
		while(old_head && !head.compare_exchange_weak(old_head,old_head->next));	//在解引用之前检查old_head不是一个空指针
		return old_head ? old_head->data : std::shared_ptr<T>();
	}
};