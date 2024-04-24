------------------------------------------------------------------------------
--                                                                          --
--                    Copyright (C) 2016-2020, AdaCore                      --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of the copyright holder nor the names of its     --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
------------------------------------------------------------------------------

with nRF.Device;
with nRF.GPIO;

package MicroBit is

   --  http://tech.microbit.org/hardware/edgeconnector_ds/

   MB_P0   : nRF.GPIO.GPIO_Point renames nRF.Device.P0_02;  --  0 pad on edge connector
   MB_P1   : nRF.GPIO.GPIO_Point renames nRF.Device.P0_03;  --  1 pad on edge connector
   MB_P2   : nRF.GPIO.GPIO_Point renames nRF.Device.P0_01;  --  2 pad on edge connector
   MB_P3   : nRF.GPIO.GPIO_Point renames nRF.Device.P0_31;  --  Display column 1
   MB_P4   : nRF.GPIO.GPIO_Point renames nRF.Device.P0_28;  --  Display column 2
   MB_P5   : nRF.GPIO.GPIO_Point renames nRF.Device.P0_14;  --  Button A
   MB_P6   : nRF.GPIO.GPIO_Point renames nRF.Device.P1_05;  --  Display column 9
   MB_P7   : nRF.GPIO.GPIO_Point renames nRF.Device.P0_11;  --  Display column 8
   MB_P8   : nRF.GPIO.GPIO_Point renames nRF.Device.P0_10;
   MB_P9   : nRF.GPIO.GPIO_Point renames nRF.Device.P0_09;  --  Display column 7
   MB_P10  : nRF.GPIO.GPIO_Point renames nRF.Device.P0_30;  --  Display column 3
   MB_P11  : nRF.GPIO.GPIO_Point renames nRF.Device.P0_23;  --  Button B
   MB_P12  : nRF.GPIO.GPIO_Point renames nRF.Device.P0_12;
   MB_P13  : nRF.GPIO.GPIO_Point renames nRF.Device.P0_17;  --  SCK
   MB_P14  : nRF.GPIO.GPIO_Point renames nRF.Device.P0_01;  --  MISO
   MB_P15  : nRF.GPIO.GPIO_Point renames nRF.Device.P0_13;  --  MOSI
   MB_P16  : nRF.GPIO.GPIO_Point renames nRF.Device.P1_02;
   MB_P19  : nRF.GPIO.GPIO_Point renames nRF.Device.P0_26;  --  SCL
   MB_P20  : nRF.GPIO.GPIO_Point renames nRF.Device.P1_00;  --  SDA

   MB_SCK  : nRF.GPIO.GPIO_Point renames MB_P13;
   MB_MISO : nRF.GPIO.GPIO_Point renames MB_P14;
   MB_MOSI : nRF.GPIO.GPIO_Point renames MB_P15;

   MB_SCL  : nRF.GPIO.GPIO_Point renames nRF.Device.P0_08;  -- internal
   MB_SDA  : nRF.GPIO.GPIO_Point renames nRF.Device.P0_16;  -- internal 
--   MB_SCL  : nRF.GPIO.GPIO_Point renames nRF.Device.P0_26;  -- external
--   MB_SDA  : nRF.GPIO.GPIO_Point renames nRF.Device.P1_00;  -- external 

   MB_UART_RX : nRF.GPIO.GPIO_Point renames nRF.Device.P1_08;  -- Attention : is declared as TX on https://tech.microbit.org/hardware/schematic/
   MB_UART_TX : nRF.GPIO.GPIO_Point renames nRF.Device.P0_06;


end MicroBit;
