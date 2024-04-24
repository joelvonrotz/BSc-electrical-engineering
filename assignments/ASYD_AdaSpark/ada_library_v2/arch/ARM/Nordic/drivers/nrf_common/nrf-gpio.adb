------------------------------------------------------------------------------
--                                                                          --
--                     Copyright (C) 2016-2020, AdaCore                     --
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

-- Quick and dirty support for two ports on NRF52 devices : refactoring reuqired !!


with NRF_SVD.GPIO; use NRF_SVD.GPIO;

package body nRF.GPIO is


   overriding
   function Mode (This : GPIO_Point) return HAL.GPIO.GPIO_Mode is
      CNF0 : PIN_CNF_Register renames GPIO_Periph_0.PIN_CNF (This.Pin);
      CNF1 : PIN_CNF_Register renames GPIO_Periph_1.PIN_CNF (This.Pin);
   begin
      case This.Port is
         when 0 =>
            case CNF0.DIR is
            when Input => return HAL.GPIO.Input;
            when Output => return HAL.GPIO.Output;
            end case;
         when 1 =>
            case CNF1.DIR is
            when Input => return HAL.GPIO.Input;
            when Output => return HAL.GPIO.Output;
            end case;
        end case;
   end Mode;

   --------------
   -- Set_Mode --
   --------------

   overriding
   procedure Set_Mode (This : in out GPIO_Point;
                       Mode : HAL.GPIO.GPIO_Config_Mode)
   is
      CNF0 : PIN_CNF_Register renames GPIO_Periph_0.PIN_CNF (This.Pin);
      CNF1 : PIN_CNF_Register renames GPIO_Periph_1.PIN_CNF (This.Pin);
   begin
         case This.Port is
         when 0 =>
            CNF0.DIR := (case Mode is
                           when HAL.GPIO.Input  => Input,
                           when HAL.GPIO.Output => Output);
            CNF0.INPUT := (case Mode is
                           when HAL.GPIO.Input  => Connect,
                           when HAL.GPIO.Output => Disconnect);
         when 1 =>
            CNF1.DIR := (case Mode is
                           when HAL.GPIO.Input  => Input,
                           when HAL.GPIO.Output => Output);
            CNF1.INPUT := (case Mode is
                           when HAL.GPIO.Input  => Connect,
                           when HAL.GPIO.Output => Disconnect);
         end case;
      end Set_Mode;


   ---------
   -- Set --
   ---------

   overriding
   function Set
     (This : GPIO_Point)
      return Boolean
   is
   begin
      case This.Port is
      when 0 => return GPIO_Periph_0.IN_k.Arr (This.Pin) = High;
      when 1 => return GPIO_Periph_1.IN_k.Arr (This.Pin) = High;
      end case;
   end Set;

   -------------------
   -- Pull_Resistor --
   -------------------

   overriding
   function Pull_Resistor (This : GPIO_Point)
                           return HAL.GPIO.GPIO_Pull_Resistor
   is
   begin
      case This.Port is
      when 0 =>
         case GPIO_Periph_0.PIN_CNF (This.Pin).PULL is
         when Disabled => return HAL.GPIO.Floating;
         when Pulldown => return HAL.GPIO.Pull_Down;
         when Pullup => return HAL.GPIO.Pull_Up;
         end case;
      when 1 =>
         case GPIO_Periph_1.PIN_CNF (This.Pin).PULL is
         when Disabled => return HAL.GPIO.Floating;
         when Pulldown => return HAL.GPIO.Pull_Down;
         when Pullup => return HAL.GPIO.Pull_Up;
         end case;
      end case;
   end Pull_Resistor;

   -----------------------
   -- Set_Pull_Resistor --
   -----------------------

   overriding
   procedure Set_Pull_Resistor (This : in out GPIO_Point;
                                Pull : HAL.GPIO.GPIO_Pull_Resistor)
   is
   begin
      GPIO_Periph_0.PIN_CNF (This.Pin).PULL :=
        (case Pull is
            when HAL.GPIO.Floating  => Disabled,
            when HAL.GPIO.Pull_Down => Pulldown,
            when HAL.GPIO.Pull_Up   => Pullup);
   end Set_Pull_Resistor;

   ---------
   -- Set --
   ---------

   overriding procedure Set
     (This : in out GPIO_Point)
   is
   begin
      case This.Port is
      when 0 => GPIO_Periph_0.OUT_k.Arr (This.Pin) := High;
      when 1 => GPIO_Periph_1.OUT_k.Arr (This.Pin) := High;
      end case;
   end Set;

   -----------
   -- Clear --
   -----------

   overriding procedure Clear
     (This : in out GPIO_Point)
   is
   begin
      case This.Port is
      when 0 => GPIO_Periph_0.OUT_k.Arr (This.Pin) := Low;
      when 1 => GPIO_Periph_1.OUT_k.Arr (This.Pin) := Low;
      end case;
   end Clear;

   ------------
   -- Toggle --
   ------------

   overriding procedure Toggle
     (This : in out GPIO_Point)
   is
   begin
      if This.Set then
         This.Clear;
      else
         This.Set;
      end if;
   end Toggle;

   ------------------
   -- Configure_IO --
   ------------------

   procedure Configure_IO
     (This   : GPIO_Point;
      Config : GPIO_Configuration)
   is
      CNF0 : PIN_CNF_Register renames GPIO_Periph_0.PIN_CNF (This.Pin);
      CNF1 : PIN_CNF_Register renames GPIO_Periph_1.PIN_CNF (This.Pin);
   begin
      case This.Port is
      when 0 =>
         CNF0.DIR := (case Config.Mode is
                     when Mode_In  => Input,
                     when Mode_Out => Output);

         CNF0.INPUT := (case Config.Input_Buffer is
                       when Input_Buffer_Connect    => Connect,
                       when Input_Buffer_Disconnect => Disconnect);

         CNF0.PULL := (case Config.Resistors is
                      when No_Pull   => Disabled,
                      when Pull_Up   => Pullup,
                      when Pull_Down => Pulldown);

         CNF0.DRIVE := (case Config.Drive is
                       when Drive_S0S1 => S0S1,
                       when Drive_H0S1 => H0S1,
                       when Drive_S0H1 => S0H1,
                       when Drive_H0H1 => H0H1,
                       when Drive_D0S1 => D0S1,
                       when Drive_D0H1 => D0H1,
                       when Drive_S0D1 => S0D1,
                       when Drive_H0D1 => H0D1);

         CNF0.SENSE := (case Config.Sense is
                       when Sense_Disabled       => Disabled,
                       when Sense_For_High_Level => High,
                       when Sense_For_Low_Level  => Low);
      when 1 =>
         CNF1.DIR := (case Config.Mode is
                     when Mode_In  => Input,
                     when Mode_Out => Output);

         CNF1.INPUT := (case Config.Input_Buffer is
                       when Input_Buffer_Connect    => Connect,
                       when Input_Buffer_Disconnect => Disconnect);

         CNF1.PULL := (case Config.Resistors is
                      when No_Pull   => Disabled,
                      when Pull_Up   => Pullup,
                      when Pull_Down => Pulldown);

         CNF1.DRIVE := (case Config.Drive is
                       when Drive_S0S1 => S0S1,
                       when Drive_H0S1 => H0S1,
                       when Drive_S0H1 => S0H1,
                       when Drive_H0H1 => H0H1,
                       when Drive_D0S1 => D0S1,
                       when Drive_D0H1 => D0H1,
                       when Drive_S0D1 => S0D1,
                       when Drive_H0D1 => H0D1);

         CNF1.SENSE := (case Config.Sense is
                       when Sense_Disabled       => Disabled,
                       when Sense_For_High_Level => High,
                       when Sense_For_Low_Level  => Low);
      end case;
   end Configure_IO;

end nRF.GPIO;

