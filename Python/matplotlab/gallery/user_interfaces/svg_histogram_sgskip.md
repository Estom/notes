# SVG直方图

演示如何创建交互式直方图，通过单击图例标记隐藏或显示条形图。

交互性以ecmascript（javascript）编码，并在后处理步骤中插入SVG代码中。 要渲染图像，请在Web浏览器中打开它。 大多数Linux Web浏览器和OSX用户都支持SVG。 Windows IE9支持SVG，但早期版本不支持。

## 注意

matplotlib后端允许我们为每个对象分配id。 这是用于描述在python中创建的matplotlib对象的机制以及在第二步中解析的相应SVG构造。 虽然灵活，但它们很难用于大量物体的收集。 可以使用两种机制来简化事情：

- 系统地将对象分组为SVG \<g\>标签，
- 根据每个SVG对象的来源为每个SVG对象分配类。

例如，不是修改每个单独栏的属性，而是可以将列分组到PatchCollection中，或者将列分配给class =“hist _ ##”属性。

CSS也可以广泛用于替换整个SVG生成中的重复标记。

作者：david.huard@gmail.com

```python
import numpy as np
import matplotlib.pyplot as plt
import xml.etree.ElementTree as ET
from io import BytesIO
import json


plt.rcParams['svg.fonttype'] = 'none'

# Apparently, this `register_namespace` method works only with
# python 2.7 and up and is necessary to avoid garbling the XML name
# space with ns0.
ET.register_namespace("", "http://www.w3.org/2000/svg")

# Fixing random state for reproducibility
np.random.seed(19680801)

# --- Create histogram, legend and title ---
plt.figure()
r = np.random.randn(100)
r1 = r + 1
labels = ['Rabbits', 'Frogs']
H = plt.hist([r, r1], label=labels)
containers = H[-1]
leg = plt.legend(frameon=False)
plt.title("From a web browser, click on the legend\n"
          "marker to toggle the corresponding histogram.")


# --- Add ids to the svg objects we'll modify

hist_patches = {}
for ic, c in enumerate(containers):
    hist_patches['hist_%d' % ic] = []
    for il, element in enumerate(c):
        element.set_gid('hist_%d_patch_%d' % (ic, il))
        hist_patches['hist_%d' % ic].append('hist_%d_patch_%d' % (ic, il))

# Set ids for the legend patches
for i, t in enumerate(leg.get_patches()):
    t.set_gid('leg_patch_%d' % i)

# Set ids for the text patches
for i, t in enumerate(leg.get_texts()):
    t.set_gid('leg_text_%d' % i)

# Save SVG in a fake file object.
f = BytesIO()
plt.savefig(f, format="svg")

# Create XML tree from the SVG file.
tree, xmlid = ET.XMLID(f.getvalue())


# --- Add interactivity ---

# Add attributes to the patch objects.
for i, t in enumerate(leg.get_patches()):
    el = xmlid['leg_patch_%d' % i]
    el.set('cursor', 'pointer')
    el.set('onclick', "toggle_hist(this)")

# Add attributes to the text objects.
for i, t in enumerate(leg.get_texts()):
    el = xmlid['leg_text_%d' % i]
    el.set('cursor', 'pointer')
    el.set('onclick', "toggle_hist(this)")

# Create script defining the function `toggle_hist`.
# We create a global variable `container` that stores the patches id
# belonging to each histogram. Then a function "toggle_element" sets the
# visibility attribute of all patches of each histogram and the opacity
# of the marker itself.

script = """
<script type="text/ecmascript">
<![CDATA[
var container = %s

function toggle(oid, attribute, values) {
    /* Toggle the style attribute of an object between two values.

    Parameters
    ----------
    oid : str
      Object identifier.
    attribute : str
      Name of style attribute.
    values : [on state, off state]
      The two values that are switched between.
    */
    var obj = document.getElementById(oid);
    var a = obj.style[attribute];

    a = (a == values[0] || a == "") ? values[1] : values[0];
    obj.style[attribute] = a;
    }

function toggle_hist(obj) {

    var num = obj.id.slice(-1);

    toggle('leg_patch_' + num, 'opacity', [1, 0.3]);
    toggle('leg_text_' + num, 'opacity', [1, 0.5]);

    var names = container['hist_'+num]

    for (var i=0; i < names.length; i++) {
        toggle(names[i], 'opacity', [1,0])
    };
    }
]]>
</script>
""" % json.dumps(hist_patches)

# Add a transition effect
css = tree.getchildren()[0][0]
css.text = css.text + "g {-webkit-transition:opacity 0.4s ease-out;" + \
    "-moz-transition:opacity 0.4s ease-out;}"

# Insert the script and save to file.
tree.insert(0, ET.XML(script))

ET.ElementTree(tree).write("svg_histogram.svg")
```

## 下载这个示例
            
- [下载python源码: svg_histogram_sgskip.py](https://matplotlib.org/_downloads/svg_histogram_sgskip.py)
- [下载Jupyter notebook: svg_histogram_sgskip.ipynb](https://matplotlib.org/_downloads/svg_histogram_sgskip.ipynb)