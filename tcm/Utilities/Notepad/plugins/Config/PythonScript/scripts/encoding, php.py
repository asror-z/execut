import os;
import sys;
filePathSrc="d:\\Develop\\Servers\\WAMP\\OpenServer\\Portable\\5_25-Prods\\domains\\localhost"

for root, dirs, files in os.walk(filePathSrc):
    for fn in files:
      if fn[-4:] == '.php':
        notepad.open(root + "\\" + fn)
        console.write(root + "\\" + fn + "\r\n")
        notepad.runMenuCommand("Encoding", "Convert to UTF-8 without BOM")
        notepad.save()
        notepad.close()