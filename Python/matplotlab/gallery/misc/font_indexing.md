# 字体索引

一个小示例，它展示了对字体表的各种索引是如何相互关联的。主要是为MPL开发商.。

输出：

```python
(6, 0, 519, 576)
36 57 65 86
AV 0
AV 0
AV 0
AV 0
```

```python
import matplotlib
from matplotlib.ft2font import FT2Font, KERNING_DEFAULT, KERNING_UNFITTED, KERNING_UNSCALED


fname = matplotlib.get_data_path() + '/fonts/ttf/DejaVuSans.ttf'
font = FT2Font(fname)
font.set_charmap(0)

codes = font.get_charmap().items()
#dsu = [(ccode, glyphind) for ccode, glyphind in codes]
#dsu.sort()
#for ccode, glyphind in dsu:
#    try: name = font.get_glyph_name(glyphind)
#    except RuntimeError: pass
#    else: print('% 4d % 4d %s %s' % (glyphind, ccode, hex(int(ccode)), name))


# make a charname to charcode and glyphind dictionary
coded = {}
glyphd = {}
for ccode, glyphind in codes:
    name = font.get_glyph_name(glyphind)
    coded[name] = ccode
    glyphd[name] = glyphind

code = coded['A']
glyph = font.load_char(code)
print(glyph.bbox)
print(glyphd['A'], glyphd['V'], coded['A'], coded['V'])
print('AV', font.get_kerning(glyphd['A'], glyphd['V'], KERNING_DEFAULT))
print('AV', font.get_kerning(glyphd['A'], glyphd['V'], KERNING_UNFITTED))
print('AV', font.get_kerning(glyphd['A'], glyphd['V'], KERNING_UNSCALED))
print('AV', font.get_kerning(glyphd['A'], glyphd['T'], KERNING_UNSCALED))
```

## 下载这个示例
            
- [下载python源码: font_indexing.py](https://matplotlib.org/_downloads/font_indexing.py)
- [下载Jupyter notebook: font_indexing.ipynb](https://matplotlib.org/_downloads/font_indexing.ipynb)