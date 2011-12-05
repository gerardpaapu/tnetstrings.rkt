from tnetstrings import *
from sys import stdin, stdout

src = ''.join(stdin.readlines())

while len(src) > 0:
    data, src = parse(src)
    print "%s %s" % (type(data), data)
