//在后台监视文件系统
std::mutex config_mutex;
std::vector<interruptible_thread> background_threads;

void background_thread(int disk_id)
{
	while(true)
	{
		interruption_point();
		fs_change fsc=get_fs_changes(disk_id);		//检查磁盘变化并且更新索引
		if(fsc.has_changes())
		{
			update_index(fsc);
		}
	}
}

void start_background_processing()
{
	background_threads.push_back(interruptible_thread(background_thread.disk_1));
	background_threads.push_back(interruptible_thread(background_thread.disk_2));
}

int main()
{
	start_background_processing();		//启动的时候，开始运行基础线程
	process_gui_until_exit();			//主线程将基础线程与处理GUI一起处理
	std::unique_lock<std::mutex> lk(config_mutex);
	for(unsigned i=0;i<background_threads.size();++i)		//用户要求退出的时候，中断这些基础程序
	{
		background_threads[i].interrupt();
	}
	for(unsigned i=0;i<background_threads.size();++i)		//等待
	{
		background_threads[i].join();
	}
}