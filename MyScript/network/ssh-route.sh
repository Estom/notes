# 使用ssh隧道远程转发，实现内网穿透
# -N：不执行远程命令，仅用于转发。
# -f：后台运行。
# -R：远程转发（反向隧道）。
# ssh -NfR 公网服务器端口:内网主机:内网端口 公网用户名@公网服务器IP
ssh -NfR 8000:localhost:22 root@8.141.4.34

# 使用autossh实现ssh隧道远程转发，实现内网穿透，能够避免网络波动，实现自动重连
# -M 0：不使用监控端口，通过 SSH 自身机制检测连接状态。
autossh -M 0 -NfR 8000:localhost:22 root@8.141.4.34

# 为了执行autossh不需要远程认证需要将当前容器的ssh公钥添加到远程服务器的authorized_keys中
ssh-copy-id root@8.141.4.34

# 需要配置公网服务器上开启远程转发服务
GatewayPorts yes
AllowTcpForwarding yes

# 配置完成后需要重启ssh服务
sudo systemctl restart sshd


# 如何关闭远程转发——本地端的ssh隧道
ps aux | grep "ssh -NfR"
kill 12345  # 替换为实际的 PID
# 或者执行如下命令
pkill -f "ssh -NfR"
# 如果是autossh执行如下命令
ps aux | grep autossh
kill 12345  # 替换为实际的 PID


# 关闭远程服务器的端口转发
netstat -tulpn | grep 8000  # 替换为你转发的端口
sudo kill 12345  # 替换为实际的 PID


# 最后，远程连接的方式如下
ssh -p 8000 estom@8.141.4.34

# 服务开机启动。去掉了-f参数不再是后台启动。服务本身就应该启动一个阻塞的命令。
autossh.service


# 修改service文件后可以这样保证配置文件生效
# 1. 重新加载 systemd 管理器配置（使服务文件更改生效）
sudo systemctl daemon-reload

# 2. 重启特定服务
sudo systemctl restart your-service-name.service

# 3. 检查服务状态
sudo systemctl status your-service-name.service