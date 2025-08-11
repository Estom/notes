
## 说明
参数高效微调（PEFT）方法在微调过程中冻结预训练模型的参数，并在其顶部添加少量可训练参数（adapters）。adapters被训练以学习特定任务的信息。这种方法已被证明非常节省内存，同时具有较低的计算使用量，同时产生与完全微调模型相当的结果。


## 使用

### 安装
```
pip install peft

```
### 加载adapter

要从huggingface的Transformers库中加载并使用PEFTadapter模型，请确保Hub仓库或本地目录包含一个adapter_config.json文件和adapter权重，如上例所示。然后，您可以使用AutoModelFor类加载PEFT adapter模型。例如，要为因果语言建模加载一个PEFT adapter模型：

指定PEFT模型id
将其传递给AutoModelForCausalLM类
```
from transformers import AutoModelForCausalLM, AutoTokenizer

peft_model_id = "ybelkada/opt-350m-lora"
model = AutoModelForCausalLM.from_pretrained(peft_model_id)
```
您也可以通过load_adapter方法来加载 PEFT adapter。

```
from transformers import AutoModelForCausalLM, AutoTokenizer

model_id = "facebook/opt-350m"
peft_model_id = "ybelkada/opt-350m-lora"

model = AutoModelForCausalLM.from_pretrained(model_id)
model.load_adapter(peft_model_id)
```

基于8bit或4bit进行加载
bitsandbytes集成支持8bit和4bit精度数据类型，这对于加载大模型非常有用，因为它可以节省内存（请参阅bitsandbytes指南以了解更多信息）。要有效地将模型分配到您的硬件，请在from_pretrained()中添加load_in_8bit或load_in_4bit参数，并将device_map="auto"设置为：

```
from transformers import AutoModelForCausalLM, AutoTokenizer

peft_model_id = "ybelkada/opt-350m-lora"
model = AutoModelForCausalLM.from_pretrained(peft_model_id, device_map="auto", load_in_8bit=True)
```

### 添加adapter

你可以使用~peft.PeftModel.add_adapter方法为一个已有adapter的模型添加一个新的adapter，只要新adapter的类型与当前adapter相同即可。例如，如果你有一个附加到模型上的LoRA adapter：

```
from transformers import AutoModelForCausalLM, OPTForCausalLM, AutoTokenizer
from peft import PeftConfig

model_id = "facebook/opt-350m"
model = AutoModelForCausalLM.from_pretrained(model_id)

lora_config = LoraConfig(
    target_modules=["q_proj", "k_proj"],
    init_lora_weights=False
)

model.add_adapter(lora_config, adapter_name="adapter_1")
```
添加一个新的adapter：

```
# attach new adapter with same config
model.add_adapter(lora_config, adapter_name="adapter_2")
```
现在您可以使用~peft.PeftModel.set_adapter来设置要使用的adapter。

```
# use adapter_1
model.set_adapter("adapter_1")
output = model.generate(**inputs)
print(tokenizer.decode(output_disabled[0], skip_special_tokens=True))

# use adapter_2
model.set_adapter("adapter_2")
output_enabled = model.generate(**inputs)
print(tokenizer.decode(output_enabled[0], skip_special_tokens=True))
```

### 启用和禁用adapters
一旦您将adapter添加到模型中，您可以启用或禁用adapter模块。要启用adapter模块：

```
from transformers import AutoModelForCausalLM, OPTForCausalLM, AutoTokenizer
from peft import PeftConfig

model_id = "facebook/opt-350m"
adapter_model_id = "ybelkada/opt-350m-lora"
tokenizer = AutoTokenizer.from_pretrained(model_id)
text = "Hello"
inputs = tokenizer(text, return_tensors="pt")

model = AutoModelForCausalLM.from_pretrained(model_id)
peft_config = PeftConfig.from_pretrained(adapter_model_id)

# to initiate with random weights
peft_config.init_lora_weights = False

model.add_adapter(peft_config)
model.enable_adapters()
output = model.generate(**inputs)
```
要禁用adapter模块：

```
model.disable_adapters()
output = model.generate(**inputs)
```

### 训练一个adapter

训练一个 PEFT adapter
PEFT适配器受Trainer类支持，因此您可以为您的特定用例训练适配器。它只需要添加几行代码即可。例如，要训练一个LoRA adapter：

如果你不熟悉如何使用Trainer微调模型，请查看微调预训练模型教程。

使用任务类型和超参数定义adapter配置（参见~peft.LoraConfig以了解超参数的详细信息）。
```
from peft import LoraConfig

peft_config = LoraConfig(
    lora_alpha=16,
    lora_dropout=0.1,
    r=64,
    bias="none",
    task_type="CAUSAL_LM",
)
```
将adapter添加到模型中。
```
model.add_adapter(peft_config)
```
现在可以将模型传递给Trainer了！
```
trainer = Trainer(model=model, ...)
trainer.train()
```
要保存训练好的adapter并重新加载它：

```
model.save_pretrained(save_dir)
model = AutoModelForCausalLM.from_pretrained(save_dir)
```