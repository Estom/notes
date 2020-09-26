# Ftface属性

这是一个演示脚本，向您展示如何使用FT2Font对象的所有属性。这些描述了全局字体属性。对于单个字符度量标准，请使用load_char返回的Glyph对象

输出：

```python
Num faces   : 1
Num glyphs  : 5343
Family name : DejaVu Sans
Style name  : Oblique
PS name     : DejaVuSans-Oblique
Num fixed   : 0
Bbox                : (-2080, -717, 3398, 2187)
EM                  : 2048
Ascender            : 1901
Descender           : -483
Height              : 2384
Max adv width       : 3461
Max adv height      : 2384
Underline pos       : -175
Underline thickness : 90
Italic           : True
Bold             : False
Scalable         : True
Fixed sizes      : False
Fixed width      : False
SFNT             : False
Horizontal       : False
Vertical         : False
Kerning          : False
Fast glyphs      : False
Multiple masters : False
Glyph names      : False
External stream  : False
['__class__', '__delattr__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__gt__', '__hash__', '__init__', '__init_subclass__', '__le__', '__lt__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', 'ascender', 'bbox', 'clear', 'descender', 'draw_glyph_to_bitmap', 'draw_glyphs_to_bitmap', 'face_flags', 'family_name', 'fname', 'get_bitmap_offset', 'get_char_index', 'get_charmap', 'get_descent', 'get_glyph_name', 'get_image', 'get_kerning', 'get_name_index', 'get_num_glyphs', 'get_path', 'get_ps_font_info', 'get_sfnt', 'get_sfnt_table', 'get_width_height', 'get_xys', 'height', 'load_char', 'load_glyph', 'max_advance_height', 'max_advance_width', 'num_charmaps', 'num_faces', 'num_fixed_sizes', 'num_glyphs', 'postscript_name', 'scalable', 'select_charmap', 'set_charmap', 'set_size', 'set_text', 'style_flags', 'style_name', 'underline_position', 'underline_thickness', 'units_per_EM']
<built-in method get_kerning of matplotlib.ft2font.FT2Font object at 0x7f6451677ed0>
```

```python
import matplotlib
import matplotlib.ft2font as ft


#fname = '/usr/local/share/matplotlib/VeraIt.ttf'
fname = matplotlib.get_data_path() + '/fonts/ttf/DejaVuSans-Oblique.ttf'
#fname = '/usr/local/share/matplotlib/cmr10.ttf'

font = ft.FT2Font(fname)

print('Num faces   :', font.num_faces)        # number of faces in file
print('Num glyphs  :', font.num_glyphs)       # number of glyphs in the face
print('Family name :', font.family_name)      # face family name
print('Style name  :', font.style_name)       # face style name
print('PS name     :', font.postscript_name)  # the postscript name
print('Num fixed   :', font.num_fixed_sizes)  # number of embedded bitmap in face

# the following are only available if face.scalable
if font.scalable:
    # the face global bounding box (xmin, ymin, xmax, ymax)
    print('Bbox                :', font.bbox)
    # number of font units covered by the EM
    print('EM                  :', font.units_per_EM)
    # the ascender in 26.6 units
    print('Ascender            :', font.ascender)
    # the descender in 26.6 units
    print('Descender           :', font.descender)
    # the height in 26.6 units
    print('Height              :', font.height)
    # maximum horizontal cursor advance
    print('Max adv width       :', font.max_advance_width)
    # same for vertical layout
    print('Max adv height      :', font.max_advance_height)
    # vertical position of the underline bar
    print('Underline pos       :', font.underline_position)
    # vertical thickness of the underline
    print('Underline thickness :', font.underline_thickness)

for style in ('Italic',
              'Bold',
              'Scalable',
              'Fixed sizes',
              'Fixed width',
              'SFNT',
              'Horizontal',
              'Vertical',
              'Kerning',
              'Fast glyphs',
              'Multiple masters',
              'Glyph names',
              'External stream'):
    bitpos = getattr(ft, style.replace(' ', '_').upper()) - 1
    print('%-17s:' % style, bool(font.style_flags & (1 << bitpos)))

print(dir(font))

print(font.get_kerning)
```

## 下载这个示例
            
- [下载python源码: ftface_props.py](https://matplotlib.org/_downloads/ftface_props.py)
- [下载Jupyter notebook: ftface_props.ipynb](https://matplotlib.org/_downloads/ftface_props.ipynb)