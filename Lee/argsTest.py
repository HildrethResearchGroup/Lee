import sys
import time

original = int(sys.argv[1])

file = open ('/Users/ohildret/Documents/Code/Research/Mines/pythonProject/file1.txt','w')
file.write("\n Original = " + str(original))

print("start")
time.sleep(5)
final = original + 1
print(final)
file.write("\n final = " + str(final))
file.close()

print("end")

