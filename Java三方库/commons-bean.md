https://commons.apache.org/
引入依赖
<dependency>
    <groupId>commons-beanutils</groupId>
    <artifactId>commons-beanutils</artifactId>
    <version>1.9.4</version>
</dependency>
1
2
3
4
5
BeanUtils/BeanUtilsBean
拷贝： cloneBean/copyProperties/copyProperty
获取：getArrayProperty/getSimpleProperty/getProperty
其他操作：setProperty设置属性 populate将Bean设置到Map中  describe将Bean转成Map  
1
2
3
PropertyUtils类
判断：isReadable/isWriteable
获取：
	getProperty/getSimpleProperty/getPropertyType 
	getReadMethod/getWriteMethod/getIndexedProperty/setIndexedProperty
	getMappedProperty/setMappedProperty/getNestedProperty/setNestedProperty  
	getPropertyDescriptor/getPropertyEditorClass
拷贝和设置：copyProperties/setProperty/setSimpleProperty /clearDescriptors  
————————————————
版权声明：本文为CSDN博主「white camel」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/m0_37989980/article/details/126396868