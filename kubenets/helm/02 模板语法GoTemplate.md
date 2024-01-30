## **Go语言的模板引擎**

Go语言内置了文本模板引擎text/template和用于HTML文档的html/templant. 它们的作用机制可以简单归纳如下:

1. 模板文件通常定义为.tmpl和.tpl为后缀(也可以使用其他后缀), 必须使用utf-8编码.
2. 模板文件中使用{{和}}包裹和标识需要传入的数据.
3. 传给模板这样的数据就可以通过点号(.)来访问,如果数据是复杂类型的数据, 可以通过{{.FieldName}}来访问它的字段.
4. 除{{和}}包裹的内容外, 其他内容均不做修改原样输出.

---

## 模板引擎的使用

Go语言模板引擎的使用可以分文三部分: 定义模板文件/解析模板文件/渲染模板文件

> 定义模板文件

其中, 定义模板文件时需要我们按照相关语法规则去编写, 后文会详细介绍.

> 解析模板文件

上面定义好了模板文件之后,可以使用下面的常用方法去解析模板文件, 得到模板对象:

```go
func (t *Template) Parse(src string) (*Template, error)
func ParseFiles(filenames ...string) (*Template, error)
func ParseGlob(pattern string) (*Template, error)
```

当然, 你也可以使用 `func New(name string) *Template`函数创建一个名为 `name`的模板, 然后对其调用上面的方法去解析模板字符串或模板文件.

> 模板渲染

渲染模板简单来说就是使用数据去填充模板, 当然实际上可能会复杂很多.

```go
func(t *Template) Execute(wr io.Writer, data interface) error
func(t *Template) ExecuteTemplate(wr io.Writer, name string, data interface{}) error
```

> 基本示例

### 定义模板文件

我们按照Go模板语法定义一个 `hello.tmpl`的模板文件, 内容如下:

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=devie-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Hello</title>
</head>
<body>
    <p>Hello {{.}}<p>
</body>
<html>
```

### 解析模板和渲染模板文件

然后我们创建一个 `main.go`文件,在其中写下HTTP server端代码如下:

```go
// main.go
func sayHello(w http.ResponseWriter, r *http.Request) {
    // 解析指定文件生成模板对象
    tmpl, err := template.ParseFiles("./hello.tmpl")
    if err != nil {
        fmt.Println("create template failed, err:", err)
        return
    }
    // 利用给定数据渲染模板, 并将结果写入w
    tmpl.Execute(w, "小明")
}

func main() {
    http.HandleFunc("/", sayHello)
    err := http.ListenAndServe(":9090", nil)
    if err != nil {
        fmt.Println("HTTP SERVER failed,err:", err)
        return
    }
}
```

将上面的 `main.go`文件编译执行, 然后使用浏览器访问 `http://127.0.0.1:9090`就能看到页面上显示了 `"Hello 小明"`. 这就是一个最简单的模板渲染的示例, Go语言模板引擎详细用法请往下阅读.

## 模板语法

### `{{.}}`

模板语法都包含在 `{{`和 `}}`中间, 其中 `{{.}}`中的点表示当前对象.

当我们传入一个结构体对象时, 我们可以根据 `.`来访问结构体的对应字段. 例如:

```go
// main.go
type UserInfo struct {
    Name string
    Gender string
    Age int
}

func sayHello(w http.ResponseWriter, r *http.Request) {
    // 解析指定文件生成模板对象
    tmpl, err := template.ParseFiles("./hello.tmpl")
    if err != nil {
        fmt.Println("create template failed,err:", err)
        return
    }
    // 利用给定数据渲染模板, 并将结果写入w
    user := UserInfo{
        Name: "小明",
        Gender: "男",
        Age: 18,
    }
    tmpl.Execute(w, user)
}
```

模板文件 `hello.tmpl`内容如下:

```html
<!DOCTYPE html>
<html lang="zh-CN">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>Hello</title>
    </head>
    <body>
        <p>Hello {{.Name}}</p>
        <p>性别：{{.Gender}}</p>
        <p>年龄：{{.Age}}</p>
    </body>
</html>
```

同理, 当我们传入的变量是map时, 也可以在模板文件中通过 `.`根据key来取值.

### 注释

```text
{{/* a comment */}}
注释, 执行时会忽略. 可以多行. 只是不能嵌套, 并且必须紧贴分界符始止.
```

### 管道pipeline

pipeline是指产生数据的操作. 比如 `{{.}}`,`{{.Name}}`等. Go模板语法中支持使用管道符号 `|`连接多个命令, 用法和unix下的管道类似: `|`前面的命令会将运算结果(或返回值)传递给后一个命令的最后一个位置.

注意: 并不是只有使用了 `|`才是pipeline. Go模板语法中, pipeline的概念是传递数据, 只要能产生数据的,都是pipeline.

### 变量

我们还可以在模板中声明变量, 用来保存传入模板的数据或其他语句生成的结构. 具体语法如下:

```text
$obj := {{.}}
```

其中 `$obj`是变量的名字, 在后续代码中就可以使用该变量了

### 移除空格

有时候我们在使用模板语法的时候会不可避免的引入一下空格或者换行符, 这样模板最终渲染出来的内容可能就和我们想的不一样,这个时候可以使用 `{{-`语法去除模板内容左侧的所有空白符号, 使用 `-}}`去除模板内容右侧的所有空白的符号.

例如:

```text
{{- .Name -}}
```

注意: `-`要紧挨 `{{`和 `}}`,同时与模板值质检需要使用空格分隔.

### 条件判断

Go模板语法中的条件判断有以下几种:

```go
{{if pipeline}} T1 {{end}}
{{if pipeline}} T1 {{else}} T0 {{end}}
{{if pipeline}} T1 {{else if pipeline}} T0 {{end}}
```

### range

Go的模板语法中使用 `range`关键字进行遍历, 有以下两种写法, 其中 `pipelien`的值必须是数组,切片,字典或者通道.

```text
{{range pipeline}}T1{{end}}
如果pipeline的值其长度为0, 不会有任何输出
{{range pipeline}}T1{{else}}T0{{end}}
如果pipeline为empty, 不改变dot并执行T0,否则dot设置为pipeline的值并执行T1.
```

### with

```text
{{with pipeline}}T1{{end}}
如果pipeline为empty不产生输出,否则将dot设为pipeline的值并执行T1.不修改外面的dot.
{{with pipeline}}T1{{else}}T0{{end}}
如果pipeline为empty, 不改变dot并执行T0,否则dot设为pipeline的值并执行T1.
```

### 预定义函数

执行模板时, 函数从两个函数字典中查找: 首先是模板函数字典, 然后是全局函数字典. 一般不在模板内定义函数, 而是使用Funcs方法添加函数到模板里.

预定义的全局函数如下:

```text
and
    函数返回它的第一个empty参数或者最后一个参数;
    就是说`and x y`等价于`if x then y else x`;所有参数都会执行;
or
    返回第一个非empty参数或者最后一个参数;
    即`or x y`等价于`if x then x else y`; 所有参数都会执行;
not
    返回它的单个参数的布尔值的否定
len 
    返回它的参数的整数类型长度
index
    执行结果为第一个参数以剩下的参数为索引/键指向的值;
    如`index x 1 2 3`返回x[1][2][3]的值; 每个被索引的主体必须是数组,切片,或者字典.
print
    即fmt.Sprint
printf
    即fmt.Sprintf
println
    即fmt.Sprintln
html
    返回与其参数的文本表示形式等效的转移HEML.
    这个函数在html/template中不可用
urlquery
    以适合嵌套到网址查询中的形式返回其参数的文本表示的转义值.
    这个函数在html/template中不可用
js
    返回与其参数的文本表示形式等效的转义javaScript.
call
    执行结果是调用第一个参数的返回值,该参数必须是函数类型,其余参数作为调用该函数的参数;
    如`call .X.Y 1 2`等价于Go语言里的dot.X.Y(1,2);
    其中Y是函数类型的字段或者字典的值,或者是其他类似情况;
    call的第一个参数的执行结果必须是函数类型的值(和预定义函数如print明显不同);
    该函数类型值必须有1到2个返回值,如果有2个返回值则后一个必须是error接口类型;
    如果有2个返回值的方法返回的error非nil,模板执行会中断并返回给调用模板的执行者该错误;
```

### 比较函数

布尔函数会将任何类型的零值视为假, 其余视为真.

下面是定义为函数的二元比较运算的集合;

```text
eq      如果arg1 == arg2则返回真
ne      如果arg1 != arg2则返回真
lt      如果arg1 < arg2则返回真
le      如果arg1 <= arg2则返回真
gt      如果arg1 > arg2则返回真
ge      如果arg1 >= arg2则返回真
```

为了简化多参数相等检测,eq(只有eq) 可以接受2个或更多个参数, 它会将第一个参数和其余参数依次比较,返回下式的结果:

```text
{{eq arg1 arg2 arg3}}
```

比较函数只适用于基本类型(或重定义的基本类型, 如`type Celsius float32). 但是,整数和浮点数不能互相比较.

### 自定义函数

Go的模板支持自定义函数.

```go
func sayHello(w http.ResponseWriter, r *http.Request) {
    htmlByte, err := ioutil.ReadFile("./hello.tmpl")
    if err != nil {
        fmt.println("read html failed,err:",err)
    }
    // 自定义一个夸人的模板函数
    kua := func(arg string)(string,error) {
        return arg + "真厉害",nil
    }
    // 采用链式操作在Parse之前调用Func添加自定义的kua函数
    tmpl,err := templage.New("hello").
                Funcs(temolate.FuncMap{"kua":kua}).
                Parse(string(htmlByte))
    if err != nil {
        fmt.println("create template failed,err:",err)
        return
    }
    user := UserInfo{
        Name: "小明",
        Gender: "男",
        Age: 18,
    }
    // 使用user渲染模板,并将结果写入w
    tmpl.Execute(w,user)
}
```

我们可以在模板文件 `hello.tmpl`中按照如下方式使用我们自定义的 `kua`函数了

```text
{{kua .Name}}
```

### 嵌套template

我们可以在template中嵌套其他的template. 这个template可以是单独的文件, 也可以是通过 `define`定义的template.

举个例子: `t.tmpl`文件内容如下:

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>tmpl test</title>
</head>
<body>

    <h1>测试嵌套template语法</h1>
    <hr>
    {{template "ul.tmpl"}}
</body>
</html>

{{ define "ol.tmpl"}}
<ol>
    <li>吃饭</li>
    <li>睡觉</li>
    <li>打豆豆</li>
</ol>
{{end}}
```

`ul.tmpl`文件内容如下:

```text
<ul>
    <li>注释</li>
    <li>日志</li>
    <li>测试</li>
</ul>
```

我们注册一个 `tmplDemo`路由处理函数

```go
http.HandleFunc("/tmpl", tmplDemo)
```

`tmplDemo`函数的具体内容如下:

```go
func tmplDemo(w http.ResponseWriter, r *http.Request) {
    tmpl, err := template.ParseFiles("./t.tmpl", "./ul.tmpl")
    if err != nil {
        fmt.Println("create template failed, err:", err)
        return
    }
    user := UserInfo {
        Name: "小明",
        Gender: "男",
        Age: 12,
    }
    tmpl.Execute(w, user)
}
```

注意: 在解析模板时, 被嵌套的模板一定要在后面解析, 例如上面的示例中 `t.tmpl`模板中嵌套了 `ul.tmpl`,所以 `ul.tmpl`要在 `t.tmpl`后进行解析.

### block

```text
{{block "name" pipeline}} T1 {{end}}
```

`block`是自定义模板 `{{define "name”}} T1 {{end}}`和执行 `{{template “name” pipeline}}`缩写, 典型的用法是定义一组根模板,然后通过在其中重心定义的快模板进行自定义

定义一个根模板 `templates/base.tmpl`，内容如下：

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>Go Templates</title>
</head>
<body>
<div class="container-fluid">
    {{block "content" . }}{{end}}
</div>
</body>
</html>
```

然后定义一个 `templates/index.tmpl`，”继承”`base.tmpl`：

```html
{{template "base.tmpl"}}

{{define "content"}}
    <div>Hello world!</div>
{{end}}
```

然后使用 `template.ParseGlob`按照正则匹配规则解析模板文件，然后通过 `ExecuteTemplate`渲染指定的模板：

```go
func index(w http.ResponseWriter, r *http.Request){
    tmpl, err := template.ParseGlob("templates/*.tmpl")
    if err != nil {
        fmt.Println("create template failed, err:", err)
        return
    }
    err = tmpl.ExecuteTemplate(w, "index.tmpl", nil)
    if err != nil {
        fmt.Println("render template failed, err:", err)
        return
    }
}
```

如果我们的模板名称冲突了, 例如不同业务线下都定义了一个 `index.tmpl`模板, 我们可以通过下面两种方法来解决.

1. 在模板文件开头使用{{define 模板名}}的语句显式的为模板命名.
2. 可以把模板文件存放在templates文件夹下面的不同目录中, 然后使用 `template.ParseGlob(“templates/**/*.tmpl”)`解析模板

### 修改默认标识符

Go标准库的模板引擎使用的花括号 `{{`和 `}}`作为标识，而许多前端框架（如 `Vue`和 `AngularJS`）也使用 `{{`和 `}}`作为标识符，所以当我们同时使用Go语言模板引擎和以上前端框架时就会出现冲突，这个时候我们需要修改标识符，修改前端的或者修改Go语言的。这里演示如何修改Go语言模板引擎默认的标识符：

```go
template.New("test").Delims("{[", "]}").ParseFiles("./t.tmpl")
```

### text/template与html/template的区别

`html/template`针对的是需要返回HTML内容的场景, 在模板渲染过程中会对一些有风险的内容进行转义,以此来防范跨站脚本攻击.

例如，我定义下面的模板文件：

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Hello</title>
</head>
<body>
    {{.}}
</body>
</html>
```

这个时候传入一段JS代码并使用 `html/template`去渲染该文件，会在页面上显示出转义后的JS内容。 `alert('嘿嘿嘿')` 这就是 `html/template`为我们做的事。

但是在某些场景下，我们如果相信用户输入的内容，不想转义的话，可以自行编写一个safe函数，手动返回一个 `template.HTML`类型的内容。示例如下：

```go
func xss(w http.ResponseWriter, r *http.Request){
    tmpl,err := template.New("xss.tmpl").Funcs(template.FuncMap{
        "safe": func(s string)template.HTML {
            return template.HTML(s)
        },
    }).ParseFiles("./xss.tmpl")
    if err != nil {
        fmt.Println("create template failed, err:", err)
        return
    }
    jsStr := `<script>alert('嘿嘿嘿')</script>`
    err = tmpl.Execute(w, jsStr)
    if err != nil {
        fmt.Println(err)
    }
}
```

这样我们只需要在模板文件不需要转义的内容后面使用我们定义好的safe函数就可以了。

```text
{{ . | safe }}
```

## 扩展Sprig

> https://masterminds.github.io/sprig/

![1706326086228](image/模板语法GoTemplate/1706326086228.png)

##  扩展Helm

### required

`required`方法允许开发者声明一个模板渲染需要的值。如果在 `values.yaml`中这个值是空的，模板就不会渲染并返回开发者提供的错误信息。

例如：

```yaml
{{required "A valid foo is required!" .Values.foo }}
```

上述示例表示当 `.Values.foo`被定义时模板会被渲染，但是未定义时渲染会失败并退出。

### include

go通过define和template实现嵌套模板，无法使用go的流水线。为使包含模板成为可能，然后对该模板的输出执行操作，Helm有一个特殊的 `include`方法：

```yaml
{{include "toYaml" $value | indent 2 }}
```

上面这个包含的模板称为 `toYaml`，并将当前值 `$value`传递给被引入的模板，一般会传递全局变量"."，然后将这个模板的输出传给 `indent`方法。

由于YAML将重要性归因于缩进级别和空白，使其在包含代码片段时变成了一种好方法。但是在相关的上下文中要处理缩进。

### tpl

`tpl`方法允许开发者在模板中使用字符串作为模板。将模板字符串作为值传给chart或渲染额外的配置文件时会很有用。 语法： `{{ tpl TEMPLATE_STRING VALUES }}`

示例：

```yaml
# values
template:"{{ .Values.name }}"
name:"Tom"

# template
{{tpl .Values.template . }}

# output
Tom
```

渲染额外的配置文件：

```yaml
# external configuration file conf/app.conf
firstName={{ .Values.firstName }}
lastName={{ .Values.lastName }}

# values
firstName:Peter
lastName:Parker

# template
{{tpl (.Files.Get "conf/app.conf") . }}

# output
firstName=Peter
lastName=Parker
```

### lookup

`lookup` 函数可以用于在运行的集群中 *查找* 资源。lookup函数简述为查找 `apiVersion, kind, namespace,name -> 资源或者资源列表`。

| parameter  | type   |
| ---------- | ------ |
| apiVersion | string |
| kind       | string |
| namespace  | string |
| name       | string |

| 命令                                     | Lookup 函数                                  |
| ---------------------------------------- | -------------------------------------------- |
| `kubectl get pod mypod -n mynamespace` | `lookup "v1" "Pod" "mynamespace" "mypod"`  |
| `kubectl get pods -n mynamespace`      | `lookup "v1" "Pod" "mynamespace" ""`       |
| `kubectl get pods --all-namespaces`    | `lookup "v1" "Pod" "" ""`                  |
| `kubectl get namespace mynamespace`    | `lookup "v1" "Namespace" "" "mynamespace"` |
| `kubectl get namespaces`               | `lookup "v1" "Namespace" "" ""`            |

当 `lookup`返回一个对象，它会返回一个字典。这个字典可以进一步被引导以获取特定值。

下面的例子将返回 `mynamespace`对象的annotations属性：

```go
(lookup "v1" "Namespace" "" "mynamespace").metadata.annotations
```
