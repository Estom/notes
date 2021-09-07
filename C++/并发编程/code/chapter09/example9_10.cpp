//因std::condition_variable而遭到破坏的interruptible_wait函数实现
void interruptible_wait(std::condition_variable& cv,std::unique_lock<std::mutex>& lk)
{
	//检测中断
	interruptible_point();
	//关联一个带interrupt_flag的条件变量
	this_thread_interrupt_flag.set_condition_variable(cv);
	//等待条件变量,这里被唤醒然后中断
	cv.wait(lk);
	//清除关联的条件变量
	this_thread_interrupt_flag.clear_condition_variable();
	//再一次检测中断
	interruptible_point();
}