import struct

def xtea_encrypt(key : bytes, block : bytes, n : int = 32, endian = "!"):
  v0, v1 = struct.unpack(endian + "2L",block)
  k = struct.unpack(endian + "4L",key)

  mask : int = 0xFFFFFFFF
  delta : int =0x9E3779B9
  sum : int = 0

  for _ in range(n):
      v0 = (v0 + ((((v1 << 4) ^ (v1 >> 5)) + v1) ^ (sum + k[sum & 3]))) & mask
      sum = (sum + delta) & mask
      v1 = (v1 + ((((v0 << 4) ^ (v0 >> 5)) + v0) ^ (sum + k[(sum >> 11) & 3]))) & mask
  return struct.pack(endian + "2L",v0,v1)

def xtea_decrypt(key : bytes, block : bytes, n : int = 32, endian = "!"):
  v0, v1 = struct.unpack(endian + "2L",block)
  k = struct.unpack(endian + "4L",key)

  mask : int = 0xFFFFFFFF
  delta : int = 0x9E3779B9
  sum : int = (delta * n) & mask

  for _ in range(n):
      v1 = (v1 - ((((v0 << 4) ^ (v0 >> 5)) + v0) ^ (sum + k[(sum >> 11) & 3]))) & mask
      sum = (sum - delta) & mask
      v0 = (v0 - ((((v1 << 4) ^ (v1 >> 5)) + v1) ^ (sum + k[sum & 3]))) & mask
  return struct.pack(endian + "2L",v0,v1)




if __name__ == "__main__":
  KEY : bytes = bytes.fromhex('0123456789ABCDEF0123456789ABCDEF')
  DATA: bytes = 'hello world'.encode("ascii")

  # get length of data
  length = len(DATA)
  # adjust length to fit blocksizes
  adjusted_length = (int((length - 1)/ 8) + 1) * 8

  # fill up remaining bytes with value 0
  input_data = DATA + b'\00' * (adjusted_length - length)

  encrypted_data : bytes = b''
  decrypted_data : bytes = b''
  print("Input Data:    ", DATA.hex())
  print("Fixed Data:    ", input_data.hex())
  for round in range(int(adjusted_length/8)):
    block = input_data[round*8:((round+1)*8)]
    encrypted_data += xtea_encrypt(key=KEY, block=block)

  print("Data Encrypted:", encrypted_data.hex())

  for round in range(int(adjusted_length/8)):
    block = encrypted_data[round*8:((round+1)*8)]
    decrypted_data += xtea_decrypt(key=KEY, block=block)

  print("Data Decrypted:", decrypted_data.hex())

  print("Success!") if decrypted_data == input_data else print("Failed!")