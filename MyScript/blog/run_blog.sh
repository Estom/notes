
nohup docsify serve -p 80 /root/gitee/notes &> blog.log &


# 使用容器的方式打包当前镜像
docker build -t my-docsify-blog .

# 运行容器
docker run -d --restart=always \
  --name docsify-blog \
  -p 3000:3000 \
  -v $(pwd):/docs \
  my-docsify-blog


docker run  --name docsify-blog \
  -p 3000:3000 \
  my-docsify-blog
# 查看日志
docker logs -f docsify-blog

# 停止 / 启动
docker stop docsify-blog
docker start docsify-blog

# 更新镜像后重新部署
docker build -t my-docsify-blog .
docker rm -f docsify-blog
docker run -d ...   # 同上


