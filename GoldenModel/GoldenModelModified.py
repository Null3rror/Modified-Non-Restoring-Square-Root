import struct
import sys
import math

def float_to_binary32(num):
    return format(struct.unpack('!I', struct.pack('!f', num))[0], '032b')

def float_to_binary64(num):
    return format(struct.unpack('!Q', struct.pack('!d', num))[0], '064b')

def binary_to_float(binary):
    return struct.unpack('!f', struct.pack('!I', int(binary, 2)))[0]

def binary_to_double(binary):
    return struct.unpack('!d', struct.pack('!Q', int(binary, 2)))[0]

def operation(line, B2FD, FD2B):

    inputBinary, outputBinaryPlus1, outputBinary = line.split()
    inputFloat = B2FD(inputBinary)
    outputFloat = B2FD(outputBinary)
    if inputFloat < 0 or outputFloat < 0:
        print("NaN\n")
        return
    inputSqrt1 = math.sqrt(inputFloat)
    inputSqrt2 = inputFloat**0.5

    inputSqrt1Binary = FD2B(inputSqrt1)
    print("inputBinary = {} outputBinaryPlus1 = {}, outputBinary = {}\ninputFloat = {} outputFloat = {}\noutputFloatSqrt1 = {}\noutputFloatSqrt2 = {}".format(inputBinary, outputBinaryPlus1, outputBinary, inputFloat, outputFloat, inputSqrt1, inputSqrt2))
    print("outputFloatSqrt1Binary = {}\ncond = {}\n".format(inputSqrt1Binary, inputSqrt1Binary == outputBinary or inputSqrt1Binary == outputBinaryPlus1))




if __name__ == '__main__':
    for line in sys.stdin:
        if line == '': # If empty string is read then stop the loop
            break
        if len(sys.argv) == 2:
            if sys.argv[1] == '1':
                operation(line, binary_to_float, float_to_binary32)
            elif sys.argv[1] == '2':
                if len(line.split()[0]) == 64:
                    operation(line, binary_to_double, float_to_binary64)
                else:
                    operation(line, binary_to_float, float_to_binary32)
            else:
                operation(line, binary_to_double, float_to_binary64)
