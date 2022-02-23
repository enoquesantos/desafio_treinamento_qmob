import os
import json
import pathlib

def read_file_info(filename):
    metainfo = os.stat(filename)
    file_extension = pathlib.Path(filename).suffix

    return {
        "permissions": metainfo.st_mode,
        "inode number": metainfo.st_mode,
        "device id": metainfo.st_mode,
        "owner id": metainfo.st_mode,
        "group id": metainfo.st_mode,
        "file size": metainfo.st_mode,
        "file type": file_extension.replace(".", ""),
    }

def path_to_dict(path):
    print("reading path: {}".format(path))

    filename = os.path.basename(path)
    d = {'name': filename}

    if os.path.isdir(path):
        d['type'] = "directory"
        d['children'] = [path_to_dict(os.path.join(path,x)) for x in os.listdir(path)]
    else:
        d['type'] = "file"
        d['meta_info'] = read_file_info(path)
    return d

with open("/home/enoque/Devel/linux-kernel-tree.json", "w") as text_file:
    text_file.write(json.dumps(path_to_dict('/home/enoque/Devel/linux-kernel')))

print("")
print("--------------------------------")
print("Finish!")
