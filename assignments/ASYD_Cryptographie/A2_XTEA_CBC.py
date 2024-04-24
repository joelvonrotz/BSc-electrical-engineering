import struct, os
import A1_XTEA

#                 +--------+                 +--------+
#   IV ----o   o--| y(i-1) |<---+        +-->| y(i-1) |---o   o---- IV
#             /   +--------+    |        |   +--------+    \
#            o                  |        |                  o
#            |                  |        |                  |
#     y(i-1) |                  |        |           y(i-1) |
#            v                  |        |                  v
#          +---+   +--------+   |  y(i)  |   +--------+   +---+
# x(i) --->|XOR|-->|   e    |---+--------+-->| e^(-1) |-->|XOR|---> x(i)
#          +---+   +--------+                +--------+   +---+

def cipher_block_chaining(block : bytes, old_block : bytes, iv : bytes, first : bool = False, endian = "!"):
  iv = struct.unpack(endian + "Q", iv)[0]
  block = list(struct.unpack(endian + "Q", block))[0]
  
  if first:
    block = block ^ iv
  else:
    old_block = list(struct.unpack(endian + "Q", old_block))[0]
    block = block ^ old_block
  
  return struct.pack(endian + "Q", block)


if __name__ == "__main__":
  KEY : bytes = bytes.fromhex('0123 4567 89AB CDEF 0123 4567 89AB CDEF')
  DATA: bytes = 'hello world'.encode("ascii")
  IV: bytes = b'deadbeef'

  # get length of data
  length = len(DATA)
  # adjust length to fit blocksizes
  adjusted_length = (int((length - 1)/ 8) + 1) * 8
  block_count = int(adjusted_length/8)

  # fill up remaining bytes with value 0
  input_data = DATA + b'\00' * (adjusted_length - length)

  encrypted_data : bytes = b''
  decrypted_data : bytes = b''
  old_block : bytes = b''
  input_block : bytes = b''
  output_block : bytes = b''

  print("Input Data:    ", DATA.hex())
  print("Fixed Data:    ", input_data.hex())

  for round in range(block_count):
    block = input_data[round*8:((round+1)*8)]

    # first CBC operation
    if round == 0:
      input_block = cipher_block_chaining(block=block, old_block=b'', iv=IV, first=True)
    else:
      input_block = cipher_block_chaining(block=block, old_block=old_block, iv=IV, first=False)
    # then enciphering
    output_block = A1_XTEA.xtea_encrypt(key=KEY, block=input_block)
    encrypted_data += output_block
    old_block = output_block

  print("Data Encrypted:", encrypted_data.hex())

  for round in range(block_count):
    block = encrypted_data[(round)*8:((round+1)*8)]
    # first deciphering
    input_block = A1_XTEA.xtea_decrypt(key=KEY, block=block)

    # then CBC operation
    if round == 0:
      output_block = cipher_block_chaining(block=input_block, old_block=b'', iv=IV, first=True)
    else:
      output_block = cipher_block_chaining(block=input_block, old_block=old_block, iv=IV, first=False)
    old_block = block

    decrypted_data += output_block

  print("Data Decrypted:", decrypted_data.hex())
  print("Success!") if decrypted_data == input_data else print("Failed!")