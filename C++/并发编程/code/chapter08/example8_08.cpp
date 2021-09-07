//使用std::async的std::for_each的并行版本
template <typename Iterator,typename Func>
void parallel_for_each(Iterator first,Iterator last,Func f)
{
	unsigned long const length=std::distance(first,last);

	if(!length)
		return;

	unsigned long const min_per_thread=25;

	if(length < (2*min_per_thread))
	{
		std::for_each(first,last,f);
	}
	else
	{
		Iterator const mid_point=first+length/2;
		//异步运行前半部分
		std::future<void> first_half=std::async(&parallel_for_each<Iterator,Func>,first,mid_point,f);
		parallel_for_each(mid_point,last,f);
		//使用std::async和get()成员函数std::future提供了异常传播语义
		first_half.get();
	}
}