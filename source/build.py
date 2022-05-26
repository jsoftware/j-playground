from pathlib import Path
import os

alltext = ""
projects = ['base/base.jproj','help/help.jproj']

for project in [os.path.join(os.path.dirname(__file__),x) for x in projects]: 
    path = os.path.dirname(project)
    files = [(path+'/'+line) for line in Path(project).read_text().split("\n") if line.endswith(".ijs")]
    # print(files)
    contents = [Path(file).read_text() for file in files]
    alltext += str.join("", contents)

alltext += "\n\n"
alltext += "cocurrent 'base'"
print(alltext, file=open("../bin/html/emj.ijs", 'w'))
print(alltext, file=open("../bin/html2/emj.ijs", 'w'))
