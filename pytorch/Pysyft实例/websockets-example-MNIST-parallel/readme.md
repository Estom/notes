# 代码中涉及到的pysyft模块。


* 发现代码中只涉及少量的syft模块。
* 可以考虑，去掉syft模块，将syft模块直接导入到当前工程中，既方便修改，也方便理解。
* 可以让最后的工程变得更小型化，并且可以定制。

## 1 pytorch相关模块

### torch.nn

### torch.nn.function

### torchvision.datasets & torchvision.transforms
> 用来下载手写体数据


### torch.jit
> 用来序列化pytorch的模型，然后进行训练。


## 2 syft相关模块


### syft
调用了hook方法，与pytorch建立联系。




### syft.workers.websocket_client.WebsocketClientWorker
实现客户端与多个服务器建立连接。

然后将连接的实体导入到rwc中，进行通信和训练迭代。


### syft.frameworks.torch.fl.utils


## 3 Python标准库

### asyncio

### logging

### argparse

### websockets
