pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__main.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__main.adb");
pragma Suppress (Overflow_Check);

package body ada_main is

   E04 : Short_Integer; pragma Import (Ada, E04, "asyd_package_E");
   E06 : Short_Integer; pragma Import (Ada, E06, "lsm303_E");
   E88 : Short_Integer; pragma Import (Ada, E88, "memory_barriers_E");
   E86 : Short_Integer; pragma Import (Ada, E86, "cortex_m__nvic_E");
   E80 : Short_Integer; pragma Import (Ada, E80, "nrf__events_E");
   E33 : Short_Integer; pragma Import (Ada, E33, "nrf__gpio_E");
   E95 : Short_Integer; pragma Import (Ada, E95, "nrf__gpio__tasks_and_events_E");
   E82 : Short_Integer; pragma Import (Ada, E82, "nrf__interrupts_E");
   E39 : Short_Integer; pragma Import (Ada, E39, "nrf__rtc_E");
   E42 : Short_Integer; pragma Import (Ada, E42, "nrf__spi_master_E");
   E68 : Short_Integer; pragma Import (Ada, E68, "nrf__tasks_E");
   E93 : Short_Integer; pragma Import (Ada, E93, "nrf__adc_E");
   E66 : Short_Integer; pragma Import (Ada, E66, "nrf__clock_E");
   E97 : Short_Integer; pragma Import (Ada, E97, "nrf__ppi_E");
   E46 : Short_Integer; pragma Import (Ada, E46, "nrf__timers_E");
   E49 : Short_Integer; pragma Import (Ada, E49, "nrf__twi_E");
   E52 : Short_Integer; pragma Import (Ada, E52, "nrf__uart_E");
   E24 : Short_Integer; pragma Import (Ada, E24, "nrf__device_E");
   E60 : Short_Integer; pragma Import (Ada, E60, "microbit__console_E");
   E58 : Short_Integer; pragma Import (Ada, E58, "microbit__i2c_E");
   E56 : Short_Integer; pragma Import (Ada, E56, "microbit__accelerometer_E");
   E91 : Short_Integer; pragma Import (Ada, E91, "microbit__ios_E");
   E64 : Short_Integer; pragma Import (Ada, E64, "microbit__time_E");
   E62 : Short_Integer; pragma Import (Ada, E62, "microbit__display_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);


   procedure adainit is
      Binder_Sec_Stacks_Count : Natural;
      pragma Import (Ada, Binder_Sec_Stacks_Count, "__gnat_binder_ss_count");

      Default_Secondary_Stack_Size : System.Parameters.Size_Type;
      pragma Import (C, Default_Secondary_Stack_Size, "__gnat_default_ss_size");
      Default_Sized_SS_Pool : System.Address;
      pragma Import (Ada, Default_Sized_SS_Pool, "__gnat_default_ss_pool");

   begin
      null;

      ada_main'Elab_Body;
      Default_Secondary_Stack_Size := System.Parameters.Runtime_Default_Sec_Stack_Size;
      Binder_Sec_Stacks_Count := 1;
      Default_Sized_SS_Pool := Sec_Default_Sized_Stacks'Address;


      E04 := E04 + 1;
      E06 := E06 + 1;
      E88 := E88 + 1;
      Cortex_M.Nvic'Elab_Spec;
      E86 := E86 + 1;
      E80 := E80 + 1;
      E33 := E33 + 1;
      E95 := E95 + 1;
      Nrf.Interrupts'Elab_Body;
      E82 := E82 + 1;
      E39 := E39 + 1;
      E42 := E42 + 1;
      E68 := E68 + 1;
      E93 := E93 + 1;
      E66 := E66 + 1;
      E97 := E97 + 1;
      E46 := E46 + 1;
      E49 := E49 + 1;
      E52 := E52 + 1;
      Nrf.Device'Elab_Spec;
      Nrf.Device'Elab_Body;
      E24 := E24 + 1;
      Microbit.Console'Elab_Body;
      E60 := E60 + 1;
      E58 := E58 + 1;
      Microbit.Accelerometer'Elab_Body;
      E56 := E56 + 1;
      Microbit.Ios'Elab_Spec;
      Microbit.Ios'Elab_Body;
      E91 := E91 + 1;
      Microbit.Time'Elab_Body;
      E64 := E64 + 1;
      Microbit.Display'Elab_Body;
      E62 := E62 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_main");

   procedure main is
      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      adainit;
      Ada_Main_Program;
   end;

--  BEGIN Object file/option list
   --   C:\dev\repo\BSc-electrical-engineering\assignments\ASYD_AdaSpark\ada_library_v2\examples\MicroBit\jumper\obj\asyd_package.o
   --   C:\dev\repo\BSc-electrical-engineering\assignments\ASYD_AdaSpark\ada_library_v2\examples\MicroBit\jumper\obj\main.o
   --   -LC:\dev\repo\BSc-electrical-engineering\assignments\ASYD_AdaSpark\ada_library_v2\examples\MicroBit\jumper\obj\
   --   -LC:\dev\repo\BSc-electrical-engineering\assignments\ASYD_AdaSpark\ada_library_v2\examples\MicroBit\jumper\obj\
   --   -LC:\dev\repo\BSc-electrical-engineering\assignments\ASYD_AdaSpark\ada_library_v2\boards\MicroBit\obj\zfp_lib_Debug\
   --   -LC:\gnat\2020-arm-elf\arm-eabi\lib\gnat\zfp-cortex-m4f\adalib\
   --   -static
   --   -lgnat
--  END Object file/option list   

end ada_main;
