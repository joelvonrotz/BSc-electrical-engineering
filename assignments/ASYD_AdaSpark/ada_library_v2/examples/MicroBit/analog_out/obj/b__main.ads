pragma Warnings (Off);
pragma Ada_95;
pragma Restrictions (No_Exception_Propagation);
with System;
with System.Parameters;
with System.Secondary_Stack;
package ada_main is


   GNAT_Version : constant String :=
                    "GNAT Version: Community 2020 (20200429-93)" & ASCII.NUL;
   pragma Export (C, GNAT_Version, "__gnat_version");

   Ada_Main_Program_Name : constant String := "_ada_main" & ASCII.NUL;
   pragma Export (C, Ada_Main_Program_Name, "__gnat_ada_main_program_name");

   procedure adainit;
   pragma Export (C, adainit, "adainit");

   procedure main;
   pragma Export (C, main, "main");

   --  BEGIN ELABORATION ORDER
   --  ada%s
   --  interfaces%s
   --  system%s
   --  ada.exceptions%s
   --  ada.exceptions%b
   --  system.machine_code%s
   --  system.parameters%s
   --  system.storage_elements%s
   --  system.storage_elements%b
   --  system.secondary_stack%s
   --  system.secondary_stack%b
   --  ada.tags%s
   --  ada.tags%b
   --  system.unsigned_types%s
   --  system.assertions%s
   --  system.assertions%b
   --  cortex_m%s
   --  cortex_m_svd%s
   --  hal%s
   --  cortex_m_svd.debug%s
   --  nrf_svd%s
   --  nrf_svd.aar%s
   --  nrf_svd.ccm%s
   --  nrf_svd.clock%s
   --  nrf_svd.ecb%s
   --  nrf_svd.ficr%s
   --  nrf_svd.gpio%s
   --  nrf_svd.gpiote%s
   --  nrf_svd.power%s
   --  nrf_svd.ppi%s
   --  nrf_svd.qdec%s
   --  nrf_svd.radio%s
   --  nrf_svd.rng%s
   --  nrf_svd.rtc%s
   --  nrf_svd.saadc%s
   --  nrf_svd.spi%s
   --  nrf_svd.temp%s
   --  nrf_svd.timer%s
   --  nrf_svd.twi%s
   --  nrf_svd.uart%s
   --  nrf_svd.wdt%s
   --  hal.gpio%s
   --  hal.i2c%s
   --  hal.spi%s
   --  hal.time%s
   --  hal.uart%s
   --  memory_barriers%s
   --  memory_barriers%b
   --  cortex_m.nvic%s
   --  cortex_m.nvic%b
   --  nrf%s
   --  nrf.events%s
   --  nrf.events%b
   --  nrf.gpio%s
   --  nrf.gpio%b
   --  nrf.gpio.tasks_and_events%s
   --  nrf.gpio.tasks_and_events%b
   --  nrf.interrupts%s
   --  nrf.interrupts%b
   --  nrf.rtc%s
   --  nrf.rtc%b
   --  nrf.spi_master%s
   --  nrf.spi_master%b
   --  nrf.tasks%s
   --  nrf.tasks%b
   --  nrf.adc%s
   --  nrf.adc%b
   --  nrf.clock%s
   --  nrf.clock%b
   --  nrf.ppi%s
   --  nrf.ppi%b
   --  nrf.timers%s
   --  nrf.timers%b
   --  nrf.twi%s
   --  nrf.twi%b
   --  nrf.uart%s
   --  nrf.uart%b
   --  nrf.device%s
   --  nrf.device%b
   --  microbit%s
   --  microbit.ios%s
   --  microbit.ios%b
   --  microbit.time%s
   --  microbit.time%b
   --  main%b
   --  END ELABORATION ORDER

end ada_main;
