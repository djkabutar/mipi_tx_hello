
from math import floor, sin
f = open("buffer.mem",'w')

message = "Hello this data is coming from the BRAM of an FPGA over MIPI Protocol"

# num = floor((640*480)/2);
# print("Number of pixels :",num)
byte_index = 0 
tmp_str = ''

for i in range (len(message)):  
    tmp_str += message[i]
    if(byte_index < 5):
        byte_index = byte_index+1
    else :
        # print("part {}".format(tmp_str))
        sz = len(tmp_str)
        tmp_str = tmp_str[::-1]
        # print("rev : ",tmp_str)
        ascii_str = ''
        for i in range(sz):
            # print(i)
            ascii_str += hex(ord(tmp_str[i]))+' '
        #    print(tmp_str)
        print(ascii_str)
        byte_index = 0    
        tmp_str = ''