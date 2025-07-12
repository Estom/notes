# 配置信息
/usr/local/bin/clash
~/.config/clash/config.yaml

# clash默认监听的http/https端口
127.0.0.1:7890  
# clash默认监听的socks5端口
127.0.0.1:7891
# clash默认的控制台端口
:::9090

# 手动启动clash
clash -d /etc/clash/config.yaml


# 将clash设置为系统服务-暂不设置，容易出问题.
# 当前已经自动启动了了服务sudo systemctl stop mihomo.service
├─mihomo.service 
│ └─20307 /opt/clash/bin/mihomo -d /opt/clash -f /opt/clash/runtime.yaml

# 将http_proxy设置为当前shell的变量
export http_proxy="http://127.0.0.1:7890"
export https_proxy="http://127.0.0.1:7890"

# 将http_proxy设置为当前用户的变量
# 将以下文件放到.bashrc中
vi ~/.bashrc
export http_proxy="http://127.0.0.1:7890"
export https_proxy="http://127.0.0.1:7890"



# 【可选】将http_proxy设置为系统变量
sudo vi /etc/environment


# 如何关闭clash
ps -ef | grep clash
lsof -i:7890
kill 12345

# 如何关闭代理
unset http_proxy
unset https_proxy

# 如果是通过服务启动的clash则需要通过服务管理命令关闭

sudo systemctl stop clash
# 以下命令可以禁用开机启动
sudo systemctl disable clash

# 如何配置git的代理
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890
git config --global http.proxy socks5://127.0.0.1:7891


# 取消git的代理
git config --global --unset http.proxy
git config --global --unset https.proxy


#如何设置ssh代理
# ~/.ssh/config
Host github.com
    HostName github.com
    User git
    # 使用 SOCKS5 代理（如 Clash/V2Ray）
    ProxyCommand nc -x 127.0.0.1:7891 %h %p
    # 或使用 HTTP 代理（需安装 proxychains）
    # ProxyCommand connect -H 127.0.0.1:7890 %h %p

# 自带的ui地址如下
http://localhost:9090/ui/