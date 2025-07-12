# 这是另外一套内网穿透方案——frp
# 客户端配置文件如下
serverAddr = "8.141.4.34"
serverPort = 7000
auth.token = "ykl123"

[[proxies]]
name = "ssh-tcp"
type = "tcp"
localIP = "127.0.0.1"
localPort = 22
remotePort = 6000



# 客户端服务文件如下
[Unit]
Description=Frp Client Service
After=network.target

[Service]
User=estom
Type=simple
ExecStart=/usr/local/bin/frpc -c /home/estom/.config/frp/frpc.toml
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target

# 客户端配置命令如下
sudo systemctl enable frpc
sudo systemctl start frpc
sudo systemctl status frpc 


# 服务端配置文件如下

[common]
bind_port = 7000           # frp 客户端连接端口
token = ykl123
dashboard_port = 7500      # web 控制台端口（可选）
dashboard_user = estom
dashboard_pwd = ykl123


# 服务端启动命令如下。服务端可以随时连接启动，不需要额外配置
nohup ./frps -c frps.ini &