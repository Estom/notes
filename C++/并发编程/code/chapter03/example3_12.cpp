//使用std::call_once的线程安全的类成员延迟初始化
class X
{
private:
	connection_info connection_details;
	connection_handle connection;
	std::once_flag connection_init_flag;

	void open_connection()
	{
		connection=connection_manager.open(connection_details);
	}
public:
	X(connection_info const& connection_details_):
		connection_details(connection_details_)
	{}
	void send_data(data_packet const& data)
	{
		std::call_once(connection_init_flag,&X::open_connection,this);
		connection_send_data(data);
	}
	data_packet receive_data()
	{
		std::call_once(connection_init_flag,&X::open_connection,this);
		return connection.receive_data();
	}
};