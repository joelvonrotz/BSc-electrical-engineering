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

with nRF.GPIO;       use nRF.GPIO;
with nRF.RTC;        use nRF.RTC;
with NRF_SVD.RTC;
with nRF.TWI;        use nRF.TWI;
with NRF_SVD.TWI;
with nRF.SPI_Master; use nRF.SPI_Master;
with NRF_SVD.SPI;
with nRF.Timers;     use nRF.Timers;
with NRF_SVD.TIMER;
with nRF.UART;       use nRF.UART;
with NRF_SVD.UART;

package nRF.Device is
   pragma Elaborate_Body;

   P0_00 : aliased GPIO_Point := (Port => 0, Pin => 00);
   P0_01 : aliased GPIO_Point := (Port => 0, Pin => 01);
   P0_02 : aliased GPIO_Point := (Port => 0, Pin => 02);
   P0_03 : aliased GPIO_Point := (Port => 0, Pin => 03);
   P0_04 : aliased GPIO_Point := (Port => 0, Pin => 04);
   P0_05 : aliased GPIO_Point := (Port => 0, Pin => 05);
   P0_06 : aliased GPIO_Point := (Port => 0, Pin => 06);
   P0_07 : aliased GPIO_Point := (Port => 0, Pin => 07);
   P0_08 : aliased GPIO_Point := (Port => 0, Pin => 08);
   P0_09 : aliased GPIO_Point := (Port => 0, Pin => 09);
   P0_10 : aliased GPIO_Point := (Port => 0, Pin => 10);
   P0_11 : aliased GPIO_Point := (Port => 0, Pin => 11);
   P0_12 : aliased GPIO_Point := (Port => 0, Pin => 12);
   P0_13 : aliased GPIO_Point := (Port => 0, Pin => 13);
   P0_14 : aliased GPIO_Point := (Port => 0, Pin => 14);
   P0_15 : aliased GPIO_Point := (Port => 0, Pin => 15);
   P0_16 : aliased GPIO_Point := (Port => 0, Pin => 16);
   P0_17 : aliased GPIO_Point := (Port => 0, Pin => 17);
   P0_18 : aliased GPIO_Point := (Port => 0, Pin => 18);
   P0_19 : aliased GPIO_Point := (Port => 0, Pin => 19);
   P0_20 : aliased GPIO_Point := (Port => 0, Pin => 20);
   P0_21 : aliased GPIO_Point := (Port => 0, Pin => 21);
   P0_22 : aliased GPIO_Point := (Port => 0, Pin => 22);
   P0_23 : aliased GPIO_Point := (Port => 0, Pin => 23);
   P0_24 : aliased GPIO_Point := (Port => 0, Pin => 24);
   P0_25 : aliased GPIO_Point := (Port => 0, Pin => 25);
   P0_26 : aliased GPIO_Point := (Port => 0, Pin => 26);
   P0_27 : aliased GPIO_Point := (Port => 0, Pin => 27);
   P0_28 : aliased GPIO_Point := (Port => 0, Pin => 28);
   P0_29 : aliased GPIO_Point := (Port => 0, Pin => 29);
   P0_30 : aliased GPIO_Point := (Port => 0, Pin => 30);
   P0_31 : aliased GPIO_Point := (Port => 0, Pin => 31);

   P1_00 : aliased GPIO_Point := (Port => 1, Pin => 00);
   P1_01 : aliased GPIO_Point := (Port => 1, Pin => 01);
   P1_02 : aliased GPIO_Point := (Port => 1, Pin => 02);
   P1_03 : aliased GPIO_Point := (Port => 1, Pin => 03);
   P1_04 : aliased GPIO_Point := (Port => 1, Pin => 04);
   P1_05 : aliased GPIO_Point := (Port => 1, Pin => 05);
   P1_06 : aliased GPIO_Point := (Port => 1, Pin => 06);
   P1_07 : aliased GPIO_Point := (Port => 1, Pin => 07);
   P1_08 : aliased GPIO_Point := (Port => 1, Pin => 08);
   P1_09 : aliased GPIO_Point := (Port => 1, Pin => 09);

   RTC_0 : aliased Real_Time_Counter (NRF_SVD.RTC.RTC0_Periph'Access);
   RTC_1 : aliased Real_Time_Counter (NRF_SVD.RTC.RTC1_Periph'Access);
   RTC_2 : aliased Real_Time_Counter (NRF_SVD.RTC.RTC2_Periph'Access);


   --  Be carefull of shared resources between the TWI and SPI controllers.
   --  TWI_O and SPI_Master_0 cannot be used at the same time.
   --  TWI_1 and SPI_Master_1 cannot be used at the same time.
   --
   --  See nRF Series Reference Manual, chapter Memory.Instantiation.

   TWI_0 : aliased TWI_Master (NRF_SVD.TWI.TWI0_Periph'Access);
   TWI_1 : aliased TWI_Master (NRF_SVD.TWI.TWI1_Periph'Access);


   SPI_Master_0 : aliased nRF.SPI_Master.SPI_Master (NRF_SVD.SPI.SPI0_Periph'Access);
   SPI_Master_1 : aliased nRF.SPI_Master.SPI_Master (NRF_SVD.SPI.SPI1_Periph'Access);
   SPI_Master_2 : aliased nRF.SPI_Master.SPI_Master (NRF_SVD.SPI.SPI2_Periph'Access);


   Timer_0 : aliased Timer (NRF_SVD.TIMER.TIMER0_Periph'Access);
   Timer_1 : aliased Timer (NRF_SVD.TIMER.TIMER1_Periph'Access);
   Timer_2 : aliased Timer (NRF_SVD.TIMER.TIMER2_Periph'Access);
   Timer_3 : aliased Timer (NRF_SVD.TIMER.TIMER3_Periph'Access);
   Timer_4 : aliased Timer (NRF_SVD.TIMER.TIMER4_Periph'Access);


   UART_0 : aliased UART_Device (NRF_SVD.UART.UART0_Periph'Access);
end nRF.Device;
