import os
import json
import pathlib
import uuid

def read_file_info(filename):
    metainfo = os.stat(filename)
    file_extension = pathlib.Path(filename).suffix

    return {
        "size": metainfo.st_mode,
        "type": file_extension.replace(".", ""),
        "url": "https://github.com/qt/qtbase/blob/dev/{}".format(filename.replace("/home/enoque/Devel/qtbase/", ""))
    }

def path_to_dict(path):
    print("reading path: {}".format(path))

    filename = os.path.basename(path)
    d = {'name': filename}

    if os.path.isdir(path):
        d['type'] = "directory"
        d['uuid'] = str(uuid.uuid4())
        d['children'] = [path_to_dict(os.path.join(path,x)) for x in os.listdir(path)]
    else:
        meta_info = read_file_info(path)
        d['type'] = "file"
        d['size'] = meta_info["size"]
        d['type'] = meta_info["type"]
        d['url'] = meta_info["url"]
    return d

with open("/home/enoque/Qt/qt-projects/desafio_treinamento_qmob/qtbase-directory-tree.json", "w") as text_file:
    text_file.write(json.dumps(path_to_dict('/home/enoque/Devel/qtbase')))

print("")
print("--------------------------------")
print("Finish!")
