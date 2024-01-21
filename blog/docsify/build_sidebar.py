from configparser import ConfigParser
from os.path import splitext, basename, join, isdir, relpath, abspath
from os import listdir
import os
import sys

# docsify根目录
# root_dir='/root/gitee/notes'
root_dir='/root/gitee/notes'
# 要处理的文件或文件夹
exclude_start_with=['_','*','.']
exclude_file = ['readme.md']
exclude_dir = ['.vscode','.git']
# 想要在几级目录生成文件,默认"0"表示在根目录生成,可以配合侧边栏折叠插件使用
create_depth=1


def good_file(base_path):
    """
    是否需要生成文件
    1. 扩展名不是md的不生成
    2. 不是README.md _sidebar.md。不生成
    3. 在跳过列表里的不生成
    :param file_path: 文件路径
    :return: 文件名（不包括扩展名）
    """
    file_extension = splitext(base_path)[1]
    if file_extension != '.md':
        return False
    
    base_name = os.path.basename(base_path)
    if base_name.lower() in exclude_file:
        return False
    
    for item in exclude_start_with:
        if base_name.startswith(item):
            return False
        
    rel_path = relpath(base_path,root_dir)
    for item in exclude_dir:
        if rel_path.startswith(item):
            return False
    return True

def good_dir(base_path):
    rel_path = relpath(base_path,root_dir)
    for item in exclude_dir:
        if rel_path.startswith(item):
            return False
    for dirpath, dirnames, filenames in os.walk(base_path):
        for filename in filenames:
            abspath = os.path.join(dirpath,filename)
            if good_file(abspath):
                return True
    
    return False

def build_next_level(base_path):
    '''
    创建下一级节点的目录_sidebar.md
    todo:排除子目录下没有md文件的子目录
    '''
    items = sorted(os.listdir(base_path))
    result = "\n"
    print("build next level:"+base_path + ",items:",items)
    for item in items:
        abspath = os.path.join(base_path,item)
        if isdir(abspath) and good_dir(abspath):
            rel_path = relpath(abspath,root_dir)
            readme_path = os.path.join(rel_path,"README.md")
            result += "- [" + item + "](" + readme_path.replace(' ','%20') + ')\n'
  
    basename = os.path.basename(base_path)
    # 如果README.md文件不存在，则创建
    sidebar_path = os.path.join(base_path,"_sidebar.md")
    with open(sidebar_path, 'w') as f:
        f.write('## '+ basename + '\n')
        f.write(result)      

def build_full_level(base_path):
    '''
    创建所有子节点的目录_sidebar.md
    '''
    print("build full path:"+base_path)
    result = deep_traverse(base_path,'')
    if '' == result:
        return 
    basename = os.path.basename(base_path)
    sidebar_path = os.path.join(base_path,"_sidebar.md")
    with open(sidebar_path, 'w') as f:
        f.write('## '+ basename + '\n')
        f.write(result)    

def deep_traverse(base_path,prefix):
    '''
    深度递归遍历
    '''
    if os.path.isfile(base_path):
        if not good_file(base_path):
            return ''
        return build_md_item(prefix,base_path)
    title = prefix + '- ' + os.path.basename(base_path) + '\n'
    result = ''
    for item in sorted(os.listdir(base_path)):
        abspath = os.path.join(base_path,item)
        result += deep_traverse(abspath,prefix+'  ')
    if '' == result:
        return ''
    return title + result

def build_readme_now(base_path):
    '''
    创建当前节点的readme文件，指向当前目录下的md文件。
    深度小于depth+1 就要生成readme文件
    '''
    if not good_dir(base_path):
        return 
    print("build readme now:"+base_path)
    readme_path = os.path.join(base_path, 'README.md')
    
    basename = os.path.basename(base_path)
    # 如果README.md文件不存在，则创建
    if not os.path.exists(readme_path):
        with open(readme_path, 'w') as f:
            f.write('## '+ basename + '\n')
            f.write(build_md_items('',base_path))
            


def build_md_items(prefix,base_path):
    '''
    todo:排除前缀不符合需求的文件
    '''
    result = "\n"
    for item in sorted(os.listdir(base_path)):
        abspath = join(base_path, item)
        if os.path.isfile(abspath) and good_file(abspath):
            result += build_md_item(prefix,abspath)
    return result

def build_md_item(prefix,file_path):

    base_name = os.path.basename(file_path)
    title = os.path.splitext(base_name)[0]
    rel_path = relpath(file_path,root_dir)
    print(root_dir,file_path,rel_path)
    return prefix + "- [" + title + "](" + rel_path.replace(' ','%20') + ')\n'
    

def layer_traverse(base_path,now,depth):
    build_readme_now(base_path)
    '''
    now=depth创建递归目录，不再按层遍历
    '''
    if now >= depth:
        build_full_level(base_path)
        return 
    
    '''
    now<depth创建下层目录，并继续递归
    '''
    build_next_level(base_path)
    items = listdir(base_path)
    for item in items:
        node = join(base_path, item)
        if isdir(node):
            layer_traverse(node,now+1,depth)



if __name__ == "__main__":
    '''
    如果默认n层目录
    第n-1层会生成n层目录的_sidebar
    第n层生成之后所有目录的_sidebar
    '''
    if len(sys.argv) > 1:
        root_dir = sys.argv[1]
        print("root_dir is：", root_dir)
    layer_traverse(root_dir,0,create_depth)
