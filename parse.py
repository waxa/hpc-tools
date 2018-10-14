#!/usr/bin/python

import sys
from os import listdir
from os.path import isfile

fileNames = []

for f in listdir("./results/") :
    if(".out" in f) :
        fileNames.append("results/" + f)

small = []
medium = []
big = []

for fileName in fileNames:

    small = []
    medium = []
    big = []

    file = open(fileName, "r")

    line = file.readline() # small test

    for i in range(3) :
        line = file.readline() # mkl

        line = file.readline().rstrip().split("s")[0] # my_dgesv
        small.append(float(line))

        line = file.readline() # ok

    line = file.readline() # medium test

    for i in range(3) :
        line = file.readline() # mkl

        line = file.readline().rstrip().split("s")[0] # my_dgesv
        medium.append(float(line))

        line = file.readline() # ok

    line = file.readline() # big test

    for i in range(3) :
        line = file.readline() # mkl

        line = file.readline().rstrip().split("s")[0] # my_dgesv
        big.append(float(line))

        line = file.readline() # ok
    
    small.sort()
    medium.sort()
    big.sort()

    print fileName
    print small[1]
    print medium[1]
    print big[1]
