from configparser import ConfigParser
from os.path import splitext, basename, join, isdir, relpath, abspath
from os import listdir


base_dir = None
start_with = None
show_file = None
ignore_file_name = None
include_start_with = None

out_file_list = []
create_depth = -1


def read_config():
    global base_dir, show_file, start_with, ignore_file_name, ReadmeFile, _sidebarFile, out_file_list, create_depth,include_start_with

    cf = ConfigParser()
    cf.read("config.ini", encoding='utf-8')
    base_dir = cf.get("config", "base_dir")
    start_with = cf.get("config", "ignore_start_with").split("|")
    show_file = cf.get("config", "show_file").split('|')
    ignore_file_name = cf.get("config", "ignore_file_name").split("|")
    include_start_with = cf.get("config", "include_start_with").split("|")

    out_file_list = cf.get("outFile", "eachFile").split("|")
    create_depth = int(cf.get("outFile", "create_depth"))


def check_file_extension(file_path):
    """
    检查文件后缀是否为指定的后缀
    :param file_path: 文件路径
    :return: 如果文件后缀为指定的后缀，返回True；否则返回False
    """
    file_extension = splitext(file_path)[1]
    if file_extension in show_file:
        return True
    else:
        return False


def check_file_name_satified(file_path):
    """
    获取文件名（不包括扩展名）
    :param file_path: 文件路径
    :return: 文件名（不包括扩展名）
    """
    file_name_with_extension = basename(file_path)
    file_name = splitext(file_name_with_extension)[0]
    if file_name[0] in start_with or file_name in ignore_file_name:
        return False
    if file_name[0] not in include_start_with:
        return False
    return True



def build_next_level(base_path):
    '''
    创建下一级节点的目录_sidebar.md
    todo:排除子目录下没有md文件的子目录
    '''
    print("build next level:"+root_path)
    items = os.listdir(base_path)
    result = "\n"
    for item in items:
        abspath = os.path.join(base_path,item)
        if isdir(abspath):
            rel_path = relpath(root_dir, base_dir)
            readme_path = os.path.join(rel_path,"README.md")
            result += "- [" + item + "](" + readme_path + ')\n'
  
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
    print("build full path"+root_path)
    result = deep_traverse(base_dir,'')
    if '' == result:
        return 
    basename = os.path.basename(base_path)
    sidebar_path = os.path.join(base_path,"_sidebar.md")
    with open(sidebar_path, 'w') as f:
        f.write('## '+ basename + '\n')
        f.write(result)    

def deep_traverse(base_dir,prefix):
    '''
    深度递归遍历
    '''
    if os.path.isfile(base_dir) 
        if base_dir.endwith('.md')
            return build_md_item(prefix,base_dir)
        else:
            return ''
    title = prefix + '- ' + os.path.basename(base_dir) + '\n'
    result = ''
    for items in os.listdir(base_dir):
        result += deep_traverse(base_dir,prefix+'  ')
    if '' == result:
        return ''
    return title + result

def build_readme_now(base_path):
    '''
    创建当前节点的readme文件，指向当前目录下的md文件。
    深度小于depth+1 就要生成readme文件
    '''
    print("build readme now:"+base_dir)
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
    items = os.listdir(base_path)
    result = "\n"
    for item in items:
        abspath = join(root, item)
        if abspath is not dir:
            result += build_md_item(prefix,item)
    return result

def build_md_item(prefix,file_path):
    base_name = os.path.basename(file_path)
    title = os.path.splitext(base_name)[0]
    return prefix + "- [" + title + "](" + relpath(root_dir, base_dir) + ')\n'
    

def layer_traverse(root,now,depth):
    build_readme_now(root)
    '''
    now=depth创建递归目录，不再按层遍历
    '''
    if now >= depth:
        build_full_level(root)
        return 
    
    '''
    now<depth创建下层目录，并继续递归
    '''
    build_next_level(root)
    items = listdir(root)
    for item in items:
        node = join(root, item)
        if isdir(node):
            layer_traverse(node,now+1,depth)

     



def save_structure(root_dir, base_dir=base_dir, depth=0):
    """
    遍历指定目录及其所有子目录，生成并保存目录结构。
    遍历方案：按层遍历当前目录，如果层数小于depth则只生成下一层的目录。如果等于depth则生成所有子节点的目录。
    :param root_dir: 要处理的根目录路径
    :param base_dir: 用来获得root_dir对base_dir的相对路径
    :param depth: 递归深度，文件夹深度。0表示根目录只在最开始生辰_sidebar，1表示两级目录
    """
    root = root_dir
    dirs = []
    files = []
    i = 0
    for item in listdir(root):
        if isdir(join(root, item)):
            dirs.append(item)
        else:
            files.append(item)
    subdir_structure = ''
    subdir_name = basename(root)




    if depth != 0:
        if create_depth == 0:
            subdir_structure += "- " + subdir_name + '\n'
        else:
            subdir_structure += "- [" + subdir_name + "](" + relpath(root, base_dir) + ')\n'
    else:
        if create_depth == 0:
            subdir_structure += "- " + "首页" + '\n'
        else:
            subdir_structure += "- [" + "首页" + "](" + relpath(root, base_dir) + ')\n'

    for file in files:
        if check_file_name_satified(join(root, file)):
            if check_file_extension(file):
                subdir_structure += "  " + "- [" + file + "](" + relpath(join(root, file),
                                                                         base_dir) + ')\n'

    for subdir in dirs:
        subdir_path = join(root, subdir)
        if check_file_name_satified(subdir_path):
            next_struct = save_structure(subdir_path, base_dir, depth + 1)
            next_struct = next_struct[:-1] if next_struct.endswith("\n") else next_struct
            next_struct = next_struct.replace("\n", "\n  ") + "\n"
            subdir_structure += "  " + next_struct

    back_struct = subdir_structure
    if depth == 1:
        subdir_structure = "- [" + "返回首页" + "](" + "" + '?id=main)\n' + subdir_structure
    elif depth != 0:
        abs_pre_path = abspath(join(root, ".."))
        rel_pre_path = relpath(abs_pre_path, base_dir)
        subdir_structure = "- [" + "返回上一级" + "](" + rel_pre_path + ')\n' + subdir_structure

    subdir_structure = subdir_structure.replace('\\', '/')
    print("%s : finished" % root_dir)
    if create_depth == -1:
        for file_name in out_file_list:
            with open(join(root, file_name), 'w', encoding="utf-8") as f:
                f.write(subdir_structure)
    else:
        if depth == 0 :
            for file_name in out_file_list:
                with open(join(root, file_name), 'w', encoding="utf-8") as f:
                    f.write(subdir_structure)
    return back_struct


class Node:
    pass


if __name__ == "__main__":
    '''
    如果默认n层目录
    第n-1层会生成n层目录的_sidebar
    第n层生成之后所有目录的_sidebar
    '''
    import os
    read_config()
    os.chdir(base_dir)
    print("cwd:"+os.getcwd())
    layer_traverse(base_dir,0,create_depth)
    # save_structure(base_dir, base_dir, 0)
