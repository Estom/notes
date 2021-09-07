//使用std::async的std::accumulate的异常安全并行版本
template <typename Iterator,typename T>
T parallel_accumulate(Iterator first,Iterator last,T init)
{
	unsigned long const length=std::distance(first,last);
	unsigned long const max_chunk_size=25;
	if(length<=max_chunk_size)
	{
		return std::accumulate(first,last,init);
	}
	else
	{
		Iterator mid_point=first;
		std::advance(mid_point,length/2);
		std::future<T> first_half_result=std::async(parallel_accumulate<Iterator,T>,first,mid_point,init);

		T second_half_result=parallel_accumulate(mid_point,last,T());
		return first_half_result.get()+second_half_result;		//出异常时，future会销毁，get()会再次抛出异常
	}
}
//这个版本使用递归将数据划分为块而不是重新计算将数据划分为块，但是它比之前的版本要简单一些，并且是异常安全的