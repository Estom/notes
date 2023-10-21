https://commons.apache.org/


### 引入依赖
```xml
<dependency>
    <groupId>commons-beanutils</groupId>
    <artifactId>commons-beanutils</artifactId>
    <version>1.9.4</version>
</dependency>
```
### BeanUtils/BeanUtilsBean
```java
拷贝： cloneBean/copyProperties/copyProperty
获取：getArrayProperty/getSimpleProperty/getProperty
其他操作：setProperty设置属性 populate将Bean设置到Map中  describe将Bean转成Map  
```

### PropertyUtils类
```java
判断：isReadable/isWriteable
获取：
	getProperty/getSimpleProperty/getPropertyType 
	getReadMethod/getWriteMethod/getIndexedProperty/setIndexedProperty
	getMappedProperty/setMappedProperty/getNestedProperty/setNestedProperty  
	getPropertyDescriptor/getPropertyEditorClass
拷贝和设置：copyProperties/setProperty/setSimpleProperty /clearDescriptors  
```