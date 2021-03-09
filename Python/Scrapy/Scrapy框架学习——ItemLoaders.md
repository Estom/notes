**ItemLoader是为了将获取文本进行分解，装载到相应的ItemLoader当中。**

**具体方法：**

**def** **parse**(self, response): l **=** ItemLoader(item**=**Product(),
response**=**response) l**.**add_xpath('name', '//div[@class="product_name"]')
l**.**add_xpath('name', '//div[@class="product_title"]')
l**.**add_xpath('price', '//p[@id="price"]') l**.**add_css('stock', 'p\#stock]')
l**.**add_value('last_updated', 'today') *\# you can also use literal values*
**return** l**.**load_item()

ItemLoader在每个字段中包含了一个输入处理器和一个输出处理器。

输入处理器收到数据时，理科提取数据，通过add_xpath(),add_css(),add_value()方法

之后输入处理器的结果被手气起来并保存到ItemLoader内。

收集到所有的数据后，调用ItemLoader.load_item()方法来填充，并得到填充后的Item对象。

这是当输出处理器和之前手机到的数据被调用。数据的结果是被分配多啊Item的最终值。
