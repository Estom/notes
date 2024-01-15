from configparser import ConfigParser
from os.path import splitext, basename, join, isdir, relpath, abspath
from os import listdir


base_dir = None
start_with = None
show_file = None
ignore_file_name = None

out_file_list = []
create_depth = -1


def read_config():
    global base_dir, show_file, start_with, ignore_file_name, ReadmeFile, _sidebarFile, out_file_list, create_depth

    cf = ConfigParser()
    cf.read("config.ini", encoding='utf-8')
    base_dir = cf.get("config", "base_dir")
    start_with = cf.get("config", "ignore_start_with").split("|")
    show_file = cf.get("config", "show_file").split('|')
    ignore_file_name = cf.get("config", "ignore_file_name").split("|")

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
    return True


def save_structure(root_dir, base_dir=base_dir, depth=0):
    """
    遍历指定目录及其所有子目录，生成并保存目录结构。
    :param root_dir: 要处理的根目录路径
    :param base_dir: 用来获得root_dir对base_dir的相对路径
    :param depth: 递归深度，文件夹深度
    """
    root = root_dir
    dirs = []
    files = []
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
            subdir_structure += "- [" + subdir_name + "](" + relpath(root, base_dir) + '\)\n'
    else:
        if create_depth == 0:
            subdir_structure += "- " + "首页" + '\n'
        else:
            subdir_structure += "- [" + "首页" + "](" + relpath(root, base_dir) + '\)\n'

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
        subdir_structure = "- [" + "返回首页" + "](" + "" + '\?id=main)\n' + subdir_structure
    elif depth != 0:
        abs_pre_path = abspath(join(root, ".."))
        rel_pre_path = relpath(abs_pre_path, base_dir)
        subdir_structure = "- [" + "返回上一级" + "](" + rel_pre_path + '\)\n' + subdir_structure

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


if __name__ == "__main__":
    read_config()
    save_structure(base_dir, base_dir, 0)
    input()
