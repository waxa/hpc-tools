#!/usr/bin/python

import sys
from os import listdir
from os.path import isfile

fileNames = []

for f in listdir("./md-results/") :
    if ".err" in f :
        fileNames.append("md-results/" + f)

ref = []
ref_O3 = []

ref_sum = 0.0
ref_O3_sum = 0.0

threads = [1, 2, 4, 8, 12, 16, 20, 24]

threads_data = {
    1 : [],
    2 : [],
    4 : [],
    8 : [],
    12 : [],
    16 : [],
    20 : [],
    24 : [],
}

threads_data_sum = {
    1 : 0.0,
    2 : 0.0,
    4 : 0.0,
    8 : 0.0,
    12 : 0.0,
    16 : 0.0,
    20 : 0.0,
    24 : 0.0,
}

threads_data_O3 = {
    1 : [],
    2 : [],
    4 : [],
    8 : [],
    12 : [],
    16 : [],
    20 : [],
    24 : [],
}

threads_data_O3_sum = {
    1 : 0.0,
    2 : 0.0,
    4 : 0.0,
    8 : 0.0,
    12 : 0.0,
    16 : 0.0,
    20 : 0.0,
    24 : 0.0,
}

for fileName in fileNames:
    file = open(fileName, "r")

    line = file.readline()

    line = file.readline().rstrip()
    ref.append(float(line))

    line = file.readline().rstrip()
    ref_O3.append(float(line))

    for n_thread in threads:
        line = file.readline()

        line = file.readline().rstrip()
        threads_data[n_thread].append(float(line))

        line = file.readline().rstrip()
        threads_data_O3[n_thread].append(float(line))


for aux in ref:
    ref_sum += aux
ref_sum /= len(ref)

for aux in ref_O3:
    ref_O3_sum += aux
ref_O3_sum /= len(ref_O3)

for n_thread in threads:
    for aux in threads_data[n_thread] :
        threads_data_sum[n_thread] += aux
    threads_data_sum[n_thread] /= len(threads_data[n_thread])

    for aux in threads_data_O3[n_thread] :
        threads_data_O3_sum[n_thread] += aux
    threads_data_O3_sum[n_thread] /= len(threads_data_O3[n_thread])

print '\n\n\\textbf{Threads} & \\textbf{ref} & \\textbf{omp} & \\textbf{speed up} & \\hline'
for n_thread in threads:
    print '%d & %.3lf & %.3lf & %.3lf & \\hline' % (int(n_thread), ref_sum, threads_data_sum[n_thread], ref_sum / threads_data_sum[n_thread])


print '\n\n\\textbf{Threads} & \\textbf{ref} & \\textbf{omp} & \\textbf{speed up} & \\hline'
for n_thread in threads:
    print '%d & %.3lf & %.3lf & %.3lf & \\hline' % (int(n_thread), ref_O3_sum, threads_data_O3_sum[n_thread], ref_O3_sum / threads_data_O3_sum[n_thread])
