https://blog.csdn.net/muyao987/article/details/125411129
### 安装
```
pip install evaluate
```

检查是否安装成功
```
python -c "import evaluate; print(evaluate.load('accuracy').compute(references=[1], predictions=[1]))"

```

### load

加载评估指标

evaluate中的每个指标都是一个单独的Python模块，通过 evaluate.load()（点击查看文档） 函数快速加载，其中load函数的常用参数如下：

* path：必选，str类型。可以是指标名（如 accuracy 或 社区的铁汁们贡献 的 muyaostudio/myeval），如果源码安装还可以是路径名（如./metrics/rouge 或 ./metrics/rogue/rouge.py）。我用的后者，因为直接传指标名会联网下载评价脚本，但单位的网不给力。
* config_name：可选，str类型。指标的配置（如 GLUE 指标的每个子集都有一个配置）
* module_type：上文三种评价类型之一，默认 metric，可选 comparison 或 measurement
* cache_dir：可选，存储临时预测和引用的路径（默认为 ~/.cache/huggingface/evaluate/)

```
import evaluate

# module_type 默认为 'metric'
accuracy = evaluate.load("accuracy")

# module_type 显式指定 'metric','comparison','measurement',防止重名。
word_length = evaluate.load("word_length", module_type="measurement") 
```

### 列出

列出可用指标
list_evaluation_modules 列出官方（和社区）里有哪些指标，还能看到点赞信息，一共三个参数：

module_type：要列出的评估模块类型，None是全部，可选metric，comparison，measurement。
include_community：是否包含社区模块，默认 True 。
with_details：返回指标的完整详细Dict信息，而不是str类型的指标名。默认 False。
```
print(evaluate.list_evaluation_modules(
	module_type="measurement", 
	include_community=True, 
	with_details=True)
)
```
评估模块都有的属性
所有评估模块都附带一系列有用的属性，这些属性有助于使用存储在 evaluate.EvaluationModuleInfo 对象中的模块，属性如下：

description：指标介绍
citation：latex参考文献
features：输入格式和类型，比如predictions、references等
inputs_description：输入参数描述文档
homepage：指标官网
license：指标许可证
codebase_urls：指标基于的代码地址
reference_urls：指标的参考地址


### 计算指标
计算指标值（一次性计算/增量计算）
方式一：一次性计算
函数：EvaluationModule.compute()，传入list/array/tensor等类型的参数references和predictions。
```
>>> import evaluate
>>> metric_name = './evaluate/metrics/accuracy'
>>> accuracy = evaluate.load(metric_name)
>>> accuracy.compute(references=[0,1,0,1], predictions=[1,0,0,1])

{'accuracy': 0.5}  # 输出结果
```
方式二：单增量的增量计算
函数： EvaluationModule.add()，用于for循环一对一对地里添加ref和pred，添加完退出循环之后统一计算指标。
```
>>> for ref, pred in zip([0,0,0,1], [0,0,0,1]):
...     accuracy.add(references=ref, predictions=pred)
... 
>>> accuracy.compute()

{'accuracy': 1.0}  # 输出结果
```

方式三：多增量的增量计算
函数： EvaluationModule.add_batch()，用于for循环多对多对地里添加ref和pred（下面例子是一次添加3对），添加完退出循环之后统一计算指标。
```
>>> for refs, preds in zip([[0,1],[0,1],[0,1]], [[1,0],[0,1],[0,1]]):
...     accuracy.add_batch(references=refs, predictions=preds)
... 
>>> accuracy.compute()

{'accuracy': 0.6666666666666666}  # 输出结果
```

### 保存评价结果
函数：evaluate.save()，参数为 path_or_file， 用于存储文件的路径或文件。如果只提供文件夹，则结果文件将以 result-%Y%m%d-%H%M%S.json的格式保存；可传 dict 类型的关键字参数 **result，**params。
```
>>> result = accuracy.compute(references=[0,1,0,1], predictions=[1,0,0,1])
>>> hyperparams = {"model": "bert-base-uncased"}
>>> evaluate.save("./results/", experiment="run 42", **result, **hyperparams)
```

### 自动评估指标
自动评估
有点像 Trainer 的封装，可以直接把 evaluate.evaluator() 用做自动评估，且能通过strategy参数的调整来计算置信区间和标准误差，有助于评估值的稳定性：
```
from transformers import pipeline
from datasets import load_dataset
from evaluate import evaluator
import evaluate

pipe = pipeline("text-classification", model="lvwerra/distilbert-imdb", device=0)
data = load_dataset("imdb", split="test").shuffle().select(range(1000))
metric = evaluate.load("accuracy")
results = eval.compute(model_or_pipeline=pipe, data=data, metric=metric,
                       label_mapping={"NEGATIVE": 0, "POSITIVE": 1},
                       strategy="bootstrap", n_resamples=200)

print(results)
>>> {'accuracy': 
...     {
...       'confidence_interval': (0.906, 0.9406749892841922),
...       'standard_error': 0.00865213251082787,
...       'score': 0.923
...     }
... }
```