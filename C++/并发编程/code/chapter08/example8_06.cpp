//从任务线程中分离GUI线程
std::thread task_thread;
std::atomic<bool> task_cancelled(false);

void gui_thread()
{
	while(true)
	{
		event_data event=get_event();
		if(event.type == quit)
			break;
		process(event);
	}

	void task()
	{
		while(!task_complete() && !task_cancelled)
		{
			do_next_operation();
		}
		if(task_cancelled)
		{
			perform_cleanup();
		}
		else
		{
			post_gui_event(task_complete);
		}
	}

	void process(event_data const& event)
	{
		switch(event.type)
		{
			case start_task:
				task_cancelled=false;
				task_thread=std::thread(task);
				break;
			case stop_task:
				task_cancelled=true;
				task_thread.join();
				break;
			case task_complete:
				task_thread.join();
				display_results();
				break;
			default:
				//...
		}
	}
}