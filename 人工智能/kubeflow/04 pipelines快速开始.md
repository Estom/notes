## 1 如何创建一个pipelines

### 部署pipelines

### 安装pipelines sdk
安装kfp的python组件
```
$ pip install kfp --upgrade
```
导入kfp相关的包
```
import kfp
import kfp.components as comp
```

### 创建管道
1. 创建合并数据的业务组件
   1. 函数的参数用 kfp.components.InputPath和 kfp.components.OutputPath注释进行修饰。这些注释让 Kubeflow Pipelines 知道提供压缩 tar 文件的路径并创建函数存储合并的 CSV 文件的路径。
   2. 用于kfp.components.create_component_from_func 返回可用于创建管道步骤的工厂函数。此示例还指定了运行此函数的基础容器映像、保存组件规范的路径以及运行时需要在容器中安装的 PyPI 包的列表。
```py
def merge_csv(file_path: comp.InputPath('Tarball'),
              output_csv: comp.OutputPath('CSV')):
  import glob
  import pandas as pd
  import tarfile

  tarfile.open(name=file_path, mode="r|gz").extractall('data')
  df = pd.concat(
      [pd.read_csv(csv_file, header=None) 
       for csv_file in glob.glob('data/*.csv')])
  df.to_csv(output_csv, index=False, header=False)


create_step_merge_csv = kfp.components.create_component_from_func(
    func=merge_csv,
    output_component_file='component.yaml', # This is optional. It saves the component spec for future use.
    base_image='python:3.7',
    packages_to_install=['pandas==1.1.4'])
```

2. 创建下载组件
   1. kfp.components.create_component_from_func使用和 创建的工厂函数来 kfp.components.load_component_from_url创建管道的任务。
```py
web_downloader_op = kfp.components.load_component_from_url(
    'https://raw.githubusercontent.com/kubeflow/pipelines/master/components/contrib/web/Download/component.yaml')
```

3. 将两个组件构成pipelines
```py
# Define a pipeline and create a task from a component:
def my_pipeline(url):
  web_downloader_task = web_downloader_op(url=url)
  merge_csv_task = create_step_merge_csv(file=web_downloader_task.outputs['data'])
  # The outputs of the merge_csv_task can be referenced using the
  # merge_csv_task.outputs dictionary: merge_csv_task.outputs['output_csv']
```

### 编译运行管道

1. 运行以下命令来编译您的管道并将其另存为pipeline.yaml.pipeline.yaml使用 Kubeflow Pipelines 用户界面上传并运行您的文件。
```
kfp.compiler.Compiler().compile(
    pipeline_func=my_pipeline,
    package_path='pipeline.yaml')
```
2. 创建Client连接到pipelines服务端
```py
client = kfp.Client("http://") # change arguments accordingly

client.create_run_from_pipeline_func(
    my_pipeline,
    arguments={
        'url': 'https://storage.googleapis.com/ml-pipeline-playground/iris-csv-files.tar.gz'
    })
```


## 2 创建构建

### 2.1设计管道组件
首先定义一段业务相关的python脚本。例如
```py
#!/usr/bin/env python3
import argparse
from pathlib import Path

# Function doing the actual work (Outputs first N lines from a text file)
def do_work(input1_file, output1_file, param1):
  for x, line in enumerate(input1_file):
    if x >= param1:
      break
    _ = output1_file.write(line)
  
# Defining and parsing the command-line arguments
parser = argparse.ArgumentParser(description='My program description')
# Paths must be passed in, not hardcoded
parser.add_argument('--input1-path', type=str,
  help='Path of the local file containing the Input 1 data.')
parser.add_argument('--output1-path', type=str,
  help='Path of the local file where the Output 1 data should be written.')
parser.add_argument('--param1', type=int, default=100,
  help='The number of lines to read from the input and write to the output.')
args = parser.parse_args()

# Creating the directory where the output file is created (the directory
# may or may not exist).
Path(args.output1_path).parent.mkdir(parents=True, exist_ok=True)

with open(args.input1_path, 'r') as input1_file:
    with open(args.output1_path, 'w') as output1_file:
        do_work(input1_file, output1_file, args.param1)

```
其执行方式如下
```py
python3 program.py --input1-path <path-to-the-input-file> \
  --param1 <number-of-lines-to-read> \
  --output1-path <path-to-write-the-output-to> 
```


### 2.2 将组件容器化

1. 创建一个Dockerfile 。 Dockerfile 指定：

基础容器镜像。例如，您的代码运行的操作系统。
需要安装代码才能运行的任何依赖项。
要复制到容器中的文件，例如该组件的可运行代码。
以下是 Dockerfile 示例。
```
FROM python:3.7
RUN python3 -m pip install keras
COPY ./src /pipelines/component/src
```

### 2.3 定义组件的实现

创建一个名为 的文件component.yaml并在文本编辑器中打开它。

创建组件的实现部分并指定容器映像的严格名称。运行build_image.sh脚本时会提供严格的图像名称。

```yaml
implementation:
  container:
    # The strict name of a container image that you've pushed to a container registry.
    image: gcr.io/my-org/my-image@sha256:a172..752f
```
command为您的组件的实现定义一个。此字段指定用于在容器中运行程序的命令行参数。

```py
implementation:
  container:
    image: gcr.io/my-org/my-image@sha256:a172..752f
    # command is a list of strings (command-line arguments). 
    # The YAML language has two syntaxes for lists and you can use either of them. 
    # Here we use the "flow syntax" - comma-separated strings inside square brackets.
    command: [
      python3, 
      # Path of the program inside the container
      /pipelines/component/src/program.py,
      --input1-path,
      {inputPath: Input 1},
      --param1, 
      {inputValue: Parameter 1},
      --output1-path, 
      {outputPath: Output 1},
    ]
```

### 2.4 定义组件的接口

1. 定义输入，请将具有以下属性的component.yaml项目添加到 列表中：inputs

* name：此输入的人类可读名称。每个输入的名称必须是唯一的。
* description：（可选。）人类可读的输入描述。
* default：（可选。）指定此输入的默认值。
* type：（可选。）指定输入的类型。详细了解 Kubeflow Pipelines SDK 中定义的类型以及类型检查在管道和组件中的工作原理。
* optional：指定此输入是否可选。该属性的值的类型为Bool，默认为False。
在此示例中，Python 程序有两个输入：

Input 1包含String数据。
Parameter 1包含一个Integer.
```py
inputs:
- {name: Input 1, type: String, description: 'Data for input 1'}
- {name: Parameter 1, type: Integer, default: '100', description: 'Number of lines to copy'}
```

1. 组件的输出将作为路径传递到您的管道。在运行时，Kubeflow Pipelines 为每个组件的输出创建一个路径。这些路径作为输入传递到组件的实现。

要在组件规范 YAML 中定义输出，请将outputs具有以下属性的项目添加到列表中：

* name：此输出的人类可读名称。每个输出的名称必须是唯一的。
* description：（可选。）人类可读的输出描述。
* type：（可选。）指定输出的类型。详细了解 Kubeflow Pipelines SDK 中定义的类型以及类型检查在管道和组件中的工作原理。

在此示例中，Python 程序返回一个输出。输出已命名 Output 1并且包含String数据。

```py
outputs:
- {name: Output 1, type: String, description: 'Output 1 data.'}

```
3. 定义组件的接口后，应该component.yaml类似于以下内容：
```yaml
name: Get Lines
description: Gets the specified number of lines from the input file.

inputs:
- {name: Input 1, type: String, description: 'Data for input 1'}
- {name: Parameter 1, type: Integer, default: '100', description: 'Number of lines to copy'}

outputs:
- {name: Output 1, type: String, description: 'Output 1 data.'}

implementation:
  container:
    image: gcr.io/my-org/my-image@sha256:a172..752f
    # command is a list of strings (command-line arguments). 
    # The YAML language has two syntaxes for lists and you can use either of them. 
    # Here we use the "flow syntax" - comma-separated strings inside square brackets.
    command: [
      python3, 
      # Path of the program inside the container
      /pipelines/component/src/program.py,
      --input1-path,
      {inputPath: Input 1},
      --param1, 
      {inputValue: Parameter 1},
      --output1-path, 
      {outputPath: Output 1},
    ]
```

### 2.5 运行组件

```py
import kfp
import kfp.components as comp

create_step_get_lines = comp.load_component_from_text("""
name: Get Lines
description: Gets the specified number of lines from the input file.

inputs:
- {name: Input 1, type: Data, description: 'Data for input 1'}
- {name: Parameter 1, type: Integer, default: '100', description: 'Number of lines to copy'}

outputs:
- {name: Output 1, type: Data, description: 'Output 1 data.'}

implementation:
  container:
    image: gcr.io/my-org/my-image@sha256:a172..752f
    # command is a list of strings (command-line arguments). 
    # The YAML language has two syntaxes for lists and you can use either of them. 
    # Here we use the "flow syntax" - comma-separated strings inside square brackets.
    command: [
      python3, 
      # Path of the program inside the container
      /pipelines/component/src/program.py,
      --input1-path,
      {inputPath: Input 1},
      --param1, 
      {inputValue: Parameter 1},
      --output1-path, 
      {outputPath: Output 1},
    ]""")

# create_step_get_lines is a "factory function" that accepts the arguments
# for the component's inputs and output paths and returns a pipeline step
# (ContainerOp instance).
#
# To inspect the get_lines_op function in Jupyter Notebook, enter 
# "get_lines_op(" in a cell and press Shift+Tab.
# You can also get help by entering `help(get_lines_op)`, `get_lines_op?`,
# or `get_lines_op??`.

# Create a simple component using only bash commands. The output of this component
# can be passed to a downstream component that accepts an input with the same type.
create_step_write_lines = comp.load_component_from_text("""
name: Write Lines
description: Writes text to a file.

inputs:
- {name: text, type: String}

outputs:
- {name: data, type: Data}

implementation:
  container:
    image: busybox
    command:
    - sh
    - -c
    - |
      mkdir -p "$(dirname "$1")"
      echo "$0" > "$1"
    args:
    - {inputValue: text}
    - {outputPath: data}
""")

# Define your pipeline 
def my_pipeline():
    write_lines_step = create_step_write_lines(
        text='one\ntwo\nthree\nfour\nfive\nsix\nseven\neight\nnine\nten')

    get_lines_step = create_step_get_lines(
        # Input name "Input 1" is converted to pythonic parameter name "input_1"
        input_1=write_lines_step.outputs['data'],
        parameter_1='5',
    )

# If you run this command on a Jupyter notebook running on Kubeflow,
# you can exclude the host parameter.
# client = kfp.Client()
client = kfp.Client(host='<your-kubeflow-pipelines-host-name>')

# Compile, upload, and submit this pipeline for execution.
client.create_run_from_pipeline_func(my_pipeline, arguments={})
```

