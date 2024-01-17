import os
from configparser import ConfigParser
from os.path import splitext, basename, join, isdir, relpath, abspath
from os import listdir
root_dir = '/root/gitee/notes/blog'
def test_walk():
    for dirpath, dirnames, filenames in os.walk(root_dir):
        print(f"Currently in directory: {dirpath}")
        for dirname in dirnames:
            print(f"Subdirectory: {dirname}")
        for filename in filenames:
            print(f"File: {filename}")

def test_list_dir():
    dir = os.listdir(root_dir)
    print(dir)
    

def build_next_level(root_path):
    '''
    创建下一级节点的目录_sidebar.md
    '''
    print("next_level"+root_path)

def build_full_level(root_path):
    '''
    创建所有子节点的目录_sidebar.md
    '''
    print("full_path"+root_path)

def build_readme_now(root_dir):
    '''
    创建当前节点的readme文件，指向当前目录下的md文件。
    深度小于depth+1 就要生成readme文件
    '''
    print("readme:"+root_dir)

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

    

# test_list_dir()
# test_walk()

layer_traverse(root_dir,0,1)