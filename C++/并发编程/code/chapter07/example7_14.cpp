//首次（很逊的）尝试修订push()
void push(T new_value)
{
	std::unique_ptr<T> new_data(new T(new_value));
	counted_node_ptr new_next;
	new_next.ptr=new node;
	new_next.external_count=1;
	for(;;)
	{
		node* const old_tail=tail.load();		//加载一个原子指针
		T* old_data=nullptr;
		if(old_tail->data.compare_exchange_strong(old_data,new_data.get()))		//解引用那个指针
		{
			old_tail->next=new_next;
			tail.store(new_next.ptr);			//更新那个指针
			new_data.release();
			break;
		}
	}
}