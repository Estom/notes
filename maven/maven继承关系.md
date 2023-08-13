https://blog.csdn.net/xiaoheihai666/article/details/125936493


今天想的是做一个springcloud项目，再导入父依赖的时候，发现有的 包爆红，显示不能找到包，我以为是maven问题，结果去setting.xml文件中看配置，确实都配置完了，也添加了阿里云镜像。又因为是maven与idea本版不相容的问题，结果发现不是。于是我新建一个项目在中加了一个本地仓库没有的包，结果发现可以进行自动导入包。

因此，问题就很明显了，在我新建的项目springcloud项目中pom文件的问题
然后，想到这是一个父工程，找到原因是中只是声明依赖，而不实现引入。所以在声明前，应该确保对应版本的依赖已经下载到了本地仓库。



1. dependencyManagement中只是声明包，如果包没有使用到，且没有下载到本地，则包会飘红。也就是说dependencyMangement中声明的GAV不会触发下载。

2. 不经dependency是树状关系，dependencymanagement出了继承的线性关系，也可以引入其他的pom构建成树状关系。所以继承关系和依赖关系都可以是很复杂的结构！。
