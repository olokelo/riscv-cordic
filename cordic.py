ATAN_Table = [11520, 6801, 3593, 1824, 916, 458, 229, 115, 57, 28, 14, 7, 4, 2, 1]

desiredAngle = 30*256

angle = 0
Y = 0
X = 155

if desiredAngle > 90*256:
    angle = 180*256
if desiredAngle > 270*256:
    angle = 360*256

for i in range(0, 14):
    if desiredAngle > angle:
        Xn = X - (Y >> i)
        Yn = Y + (X >> i)
        angle = angle + ATAN_Table[i]
    else:
        Xn = X + (Y >> i)
        Yn = Y - (X >> i)
        angle = angle - ATAN_Table[i]
    X = Xn
    Y = Yn

if desiredAngle > 90*256 and desiredAngle <= 270*256:
    X = -X
    Y = -Y

cos = X
sin = Y

print(sin, cos)

