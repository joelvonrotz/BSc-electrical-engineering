
INPUT_DATA: list = list("AB".encode('ascii'))
KEY: list = [0x01234567, 0x89ABCDEF, 0x01234567, 0x89ABCDEF]
AMOUNT_CYCLES: int = 16

def encipher (number_cycles : int, value : list, key : list) -> list:
  DELTA: int = 0x9E3779B9
  
  value0: int = value[0] & 0xFFFFFFFF
  value1: int = value[1] & 0xFFFFFFFF
  sum: int = 0

  for i in range(number_cycles):
    value0 = (value0 + (((value1 << 4) ^ (value1 >> 5)) + value1) ^ (sum + key[sum & 3])) & 0xFFFFFFFF
    sum = (sum + DELTA) & 0xFFFFFFFF
    value1 = (value1 + (((value0 << 4) ^ (value0 >> 5)) + value0) ^ (sum + key[(sum >> 11) & 3])) & 0xFFFFFFFF

    pass
  value[0] = value0
  value[1] = value1
  return value

def decipher (number_cycles : int, value : list, key : list) -> list:
  DELTA: int = 0x9E3779B9
  
  value0: int = value[0] & 0xFFFFFFFF
  value1: int = value[1] & 0xFFFFFFFF
  sum: int = (DELTA * number_cycles) & 0xFFFFFFFF 

  for i in range(number_cycles):
    value1 = (value1 - (((value0 << 4) ^ (value0 >> 5)) + value0) ^ (sum + key[(sum >> 11) & 3])) & 0xFFFFFFFF
    sum = (sum - DELTA) & 0xFFFFFFFF
    value0 = (value0 - (((value1 << 4) ^ (value1 >> 5)) + value1) ^ (sum + key[sum & 3])) & 0xFFFFFFFF

    pass
  value[0] = value0
  value[1] = value1
  return value


print("input: ",  INPUT_DATA)
result = encipher(AMOUNT_CYCLES, INPUT_DATA, KEY)
print("output: ", decipher(AMOUNT_CYCLES, result, KEY))