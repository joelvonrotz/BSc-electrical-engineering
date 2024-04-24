------------------------------------------------------------------------------
--                                                                          --
--                       Copyright (C) 2018, AdaCore                        --
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
with MicroBit.Console;
with MicroBit.Time;
with MicroBit.IOs;

use MicroBit;


procedure Main is

   Value : MicroBit.IOs.Analog_Value;
begin

    Console.Put_Line ("Start ADC process .. ");
--  Loop forever
   loop

      Console.Put_Line (" - ");
      --  Read analog value of pin

      Value := MicroBit.IOs.Analog (0);
      Console.Put_Line ("Value  0 : " & Value'Image);

      Value := MicroBit.IOs.Analog (1);
      Console.Put_Line ("Value  1 : " & Value'Image);

       Value := MicroBit.IOs.Analog (2);
      Console.Put_Line ("Value  2 : " & Value'Image);

      Value := MicroBit.IOs.Analog (3);
      Console.Put_Line ("Value  3 : " & Value'Image);

      Value := MicroBit.IOs.Analog (4);
      Console.Put_Line ("Value  4 : " & Value'Image);

      Value := MicroBit.IOs.Analog (10);
      Console.Put_Line ("Value 10 : " & Value'Image);

      -- Write analog value of pin 0
      -- MicroBit.IOs.Write (0, Value);
      Time.Sleep (100);

   end loop;
end Main;
