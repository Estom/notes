//简单ATM实现的getting_pin状态函数
void atm::getting_pin()
{
	incoming.wait()
	//每一次对handle()的调用将消息类型指定为模板参数，然后
	//接受特定消息类型作为参数的Lambda函数。
		.handle<digit_pressed>(
			[&](digit_pressed const& msg)
			{
				unsigned const pin_length=4;
				pin+=msg.digit;
				if(pin.length()==pin_length)
				{
					bank.send(verify_pin(account,pin,incoming));
					state=&atm::verifying_pin;
				}
			}
			)

		.handle<clear_last_prossed>(
			[&](clear_last_prossed const& msg)
			{
				if(!pin.empty())
				{
					pin.resize(pin.length()-1);
				}
			}
			)

		.handle<cancel_pressed>(
			[&](cancel_pressed const& msg)
			{
				state=&atm::done_processing;
			}
			);
}