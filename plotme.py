# plotme.py: plots data from ./dump output
# usage example:
# $ ./dump > out.txt
# $ python3 plotme.py out.txt sin

import matplotlib.pyplot as plt
import numpy as np
import sys

if len(sys.argv) != 3:
    print("Usage: plotme.py [input file] sin|cos")
    exit(1)

plot_sin = False
if sys.argv[2] == "sin":
    plot_sin = True

data_in = []
data_out = []

f = open(sys.argv[1], 'r')
while True:
    curline = f.readline()
    if curline == '':
        break
    val, sinout, cosout = curline.split(',')
    val = int(val)
    sinout = int(sinout)
    cosout = int(cosout)
    data_in.append(0.0174532925*(val/256))
    if plot_sin:
        data_out.append(sinout/256)
    else:
        data_out.append(cosout/256)
f.close()

data_ref = np.sin(data_in) if plot_sin else np.cos(data_in)

fig = plt.figure()
ax = fig.add_subplot(1, 1, 1)
ax.spines['left'].set_position('center')
ax.spines['bottom'].set_position('center')
ax.spines['right'].set_color('none')
ax.spines['top'].set_color('none')
ax.xaxis.set_ticks_position('bottom')
ax.yaxis.set_ticks_position('left')

plt.plot(data_in,data_ref, data_in,data_out)

plt.title("Sine function" if plot_sin else "Cosine function")
plt.legend(['numpy.sin' if plot_sin else "numpy.cos", 'RISC-V CORDIC implementation'])

plt.show()


