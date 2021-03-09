Spider类定义了如何爬去某个网站，包括爬去的动作、分析某个网页。

这个流程再清晰一下 发送请求-\>返回网页-\>分析处理生成数据-\>保存。

对爬虫过程的描述：

1.  初始的URL初始化Request，设置回调函数。下载完成，生成response，并作为参数传给该回调函数。start_requests()来获取start_urls.

2.  在回调函数内分析返回的网页内容，返回Item对象，或者Request或者一个包括而止的可迭代的容器。放回的Response对象经过处理，调用callback函数。

3.  在回调函数内可以使用选择器（Xpath解析器等任何解析器）来分析内容，并根据分析，生成数据item

4.  最后，spider返回的item将被存到数据库中或者导入文件当中。

Spider crawl mysqpider -a category=electronics
传递spider的参数，限定爬去网站的部分。

函数的调用流程

spider的构成：

name 名字，作用域内唯一。

allowed_domains可选，包含了spider爬取的域名domain列表list

start_urls 从该列表脏欧冠呢开始进行爬去。

start_requests()必须返回一个可迭代对象。该对象包含了spider用于爬去的第一个Request。make_reuest_from_url()将被调用来创建Request对象。

make_requests_from_url(url)该方法接受URL返回requests对象。将URL转换为Request对象。parse()作为回调函数。

parse(response)当response没有指定回调函数时，该方法是scrapy处理下载的response的默认方法。parse负责处理response并返回处理的数据以及跟进的URL。所有的Request回调函数必须范式一个包含Request或Item的可迭代的对象。

log(mewwage[,level,component])日志记录

closed(reason)spider关闭时这个函数被调用。

Spider的样例

**import** scrapy**from** myproject.items **import** MyItem**class**
**MySpider**(scrapy**.**Spider): name **=** 'example.com' allowed_domains **=**
['example.com'] start_urls **=** [ 'http://www.example.com/1.html',
'http://www.example.com/2.html', 'http://www.example.com/3.html', ] **def**
**parse**(self, response): sel **=** scrapy**.**Selector(response) **for** h3
**in** response**.**xpath('//h3')**.**extract(): **yield** MyItem(title**=**h3)
**for** url **in** response**.**xpath('//a/@href')**.**extract(): **yield**
scrapy**.**Request(url, callback**=**self**.**parse)

CrawlSpider ( scrapy.contrib.spiders.CrawlSpider)

>   rules 包含多个Rule对象的列表。

>   parse_start_url(response)当start_url的请求返回时，该方法被调用。

XMLFeedSpider

CSVFeedSpider

SitemapSpider

爬取规则(scrapy.contrib.spiders.Rule())

link_extractor 是一个LinkExtracto对象，定义了如何从爬取到的页面提取链接。

callback当从link_extractor中获取到链接之后，将会调用该函数。该回调函数接受一个response作为第一个参数，并返回一个包含Item以及Request对象的列表。（不要使用parse）

cb_kwargs传递给回调函数的参数的字典。

follow是一个Boolean，从response中提取的链接是否需要跟进。

process_links该方法用来过滤，也是回调函数。

process_request该规则提取到的每个request队徽调用这个函数，并且返回一个request或者None。
