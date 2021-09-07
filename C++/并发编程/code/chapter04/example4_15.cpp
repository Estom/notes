//ATM逻辑类的简单实现
struct card_inserted
{
	std::string account;
};
class atm
{
	messaging::receiver incoming;
	messaging::sender bank;
	messaging::sender interface_hardware;
	void (atm::*state)();

	std::string account;
	std::string pin;

	void waiting_for_card()
	{
		interface_hardware.send(display_enter_card());
		//wait如果接收到消息不匹配指定的类型，他将被丢弃。
		incoming.wait()
			.handle<card_inserted>([&](card_inserted const& msg)
				{
					account=msg.account;
					pin="";
					interface_hardware.send(display_enter_pin());
					state=&atm::getting_pin;
				}
				);
	}
	void getting_pin();
public:
	void run()
	{
		state=&atm::waiting_for_card;
		try
		{
			for(;;)
			{
				(this->*state)();
			}
		}
		catch(messaging::close_queue const&)
		{
		}
	}
};