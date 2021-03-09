全局命令\<不需要要项目，在命令行中直接运行\>：

scrapy startproject myproject

\- 创建一个名为myproject的scrapy项目

scrapy genspider [-t template] \<name\> \<domain\>

\- 创建一个新的spider(-l 列出spider的模板，-d 查看模板的内容 -t 使用这个模板)

scrapy -h

\- 查看所有可用的命令

scrapy crawl \<spider\>

\- 使用spider进行爬虫

scrapy check [l] \<spider\>

\- 运行contract检查

scrapy list

\- 列出所欲可能的spider

scrapy edit \<spider\>

\- 使用设定的编辑器编辑spider

scrapy fetch \<url\>

\- 使用scrapy下载器Downloader下载给定的URL，并将获取到的内容标准输出

scrapy view \<url\>

\- 用来查看spider获取到的页面，因为可能spider获取到的页面跟想要的不同。

scrapy shell [url]

\-scrapy 终端，能够使用scrapy内部命令对url返回的内容进行操作。

scrapy parse \<url\> [options]

\- 获取给定的URL并使用相应的spider分析处理。

scrapy settings [options]

\- 获取scrapy的设定。

scrapy runspider \<spider_file.py\>

\- 在未创建项目的情况下，运行在一个编写在python文件中的spider

scrapy -version [-v]

\- 输出scrapy版本

scrapy deploy []

\- 将仙姑部署到scrapyd服务。

scrapy bench

\- 运行benchmark测试。
