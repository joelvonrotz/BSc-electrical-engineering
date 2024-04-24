------------------------------------------------------------------------------
--                                                                          --
--                       Copyright (C) 2017, AdaCore                        --
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

with HAL;        use HAL;
with HAL.I2C;    use HAL.I2C;

private with Ada.Unchecked_Conversion;

package LSM303 is

   type LSM303_Accelerometer (Port : not null Any_I2C_Port)
   is tagged limited private;


   type Data_Rate is (DR_1_Hz, DR_10_Hz, DR_25_Hz,
                      DR_50_Hz, DR_100_Hz, DR_200_Hz, DR_400_Hz);

   procedure Configure (This                : in out LSM303_Accelerometer);

   function Check_Device_Id (This : LSM303_Accelerometer) return Boolean;
   --  Return False if device ID in incorrect or cannot be read

   type Axis_Data is range -2 ** 9 .. 2 ** 9 - 1
     with Size => 10;

   type All_Axes_Data is record
      X, Y, Z : Axis_Data;
   end record;

   function Read_Data (This : LSM303_Accelerometer) return All_Axes_Data;

private
   type LSM303_Accelerometer (Port : not null Any_I2C_Port) is tagged limited
     null record;


   for Data_Rate use (DR_1_Hz   => 1,
                      DR_10_Hz  => 2,
                      DR_25_Hz  => 3,
                      DR_50_Hz  => 4,
                      DR_100_Hz => 5,
                      DR_200_Hz => 6,
                      DR_400_Hz => 7);

   type Register_Addresss is new UInt8;

   Device_Id  : constant := 16#33#;

   Device_Address : constant I2C_Address := 16#32#;
--   Device_Address : constant I2C_Address := 16#32#;

   STATUS_REG : constant Register_Addresss := 16#27#;
   Who_Am_I   : constant Register_Addresss := 16#0F#;
   CTRL_REG1  : constant Register_Addresss := 16#20#;
   AUTO_INC   : constant Register_Addresss := 16#80#; -- set MSB to 1 to auto increment

   type CTRL_REG1_Register is record
      X_en      : Boolean := True;
      Y_en      : Boolean := True;
      Z_en      : Boolean := True;
      LP_en     : Boolean := False;
      Data_Rate : UInt4   := DR_100_Hz'Enum_Rep;
   end record;

   for CTRL_REG1_Register use record
      X_en      at 0 range 0 .. 0; -- LSB
      Y_en      at 0 range 1 .. 1;
      Z_en      at 0 range 2 .. 2;
      LP_en     at 0 range 3 .. 3;
      Data_Rate at 0 range 4 .. 7;
   end record;

   function To_UInt8 is new Ada.Unchecked_Conversion
     (CTRL_REG1_Register, UInt8);
   function To_Reg is new Ada.Unchecked_Conversion
     (UInt8, CTRL_REG1_Register);

end LSM303;
