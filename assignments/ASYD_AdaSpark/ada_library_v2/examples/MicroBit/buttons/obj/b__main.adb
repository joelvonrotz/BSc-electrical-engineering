pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__main.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__main.adb");
pragma Suppress (Overflow_Check);

package body ada_main is

   E78 : Short_Integer; pragma Import (Ada, E78, "memory_barriers_E");
   E76 : Short_Integer; pragma Import (Ada, E76, "cortex_m__nvic_E");
   E70 : Short_Integer; pragma Import (Ada, E70, "nrf__events_E");
   E28 : Short_Integer; pragma Import (Ada, E28, "nrf__gpio_E");
   E72 : Short_Integer; pragma Import (Ada, E72, "nrf__interrupts_E");
   E34 : Short_Integer; pragma Import (Ada, E34, "nrf__rtc_E");
   E37 : Short_Integer; pragma Import (Ada, E37, "nrf__spi_master_E");
   E58 : Short_Integer; pragma Import (Ada, E58, "nrf__tasks_E");
   E56 : Short_Integer; pragma Import (Ada, E56, "nrf__clock_E");
   E41 : Short_Integer; pragma Import (Ada, E41, "nrf__timers_E");
   E44 : Short_Integer; pragma Import (Ada, E44, "nrf__twi_E");
   E48 : Short_Integer; pragma Import (Ada, E48, "nrf__uart_E");
   E06 : Short_Integer; pragma Import (Ada, E06, "nrf__device_E");
   E54 : Short_Integer; pragma Import (Ada, E54, "microbit__time_E");
   E52 : Short_Integer; pragma Import (Ada, E52, "microbit__buttons_E");
   E81 : Short_Integer; pragma Import (Ada, E81, "microbit__display_E");

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


      E78 := E78 + 1;
      Cortex_M.Nvic'Elab_Spec;
      E76 := E76 + 1;
      E70 := E70 + 1;
      E28 := E28 + 1;
      Nrf.Interrupts'Elab_Body;
      E72 := E72 + 1;
      E34 := E34 + 1;
      E37 := E37 + 1;
      E58 := E58 + 1;
      E56 := E56 + 1;
      E41 := E41 + 1;
      E44 := E44 + 1;
      E48 := E48 + 1;
      Nrf.Device'Elab_Spec;
      Nrf.Device'Elab_Body;
      E06 := E06 + 1;
      Microbit.Time'Elab_Body;
      E54 := E54 + 1;
      Microbit.Buttons'Elab_Body;
      E52 := E52 + 1;
      Microbit.Display'Elab_Body;
      E81 := E81 + 1;
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
   --   C:\dev\repo\BSc-electrical-engineering\assignments\ASYD_AdaSpark\ada_library_v2\examples\MicroBit\buttons\obj\main.o
   --   -LC:\dev\repo\BSc-electrical-engineering\assignments\ASYD_AdaSpark\ada_library_v2\examples\MicroBit\buttons\obj\
   --   -LC:\dev\repo\BSc-electrical-engineering\assignments\ASYD_AdaSpark\ada_library_v2\examples\MicroBit\buttons\obj\
   --   -LC:\dev\repo\BSc-electrical-engineering\assignments\ASYD_AdaSpark\ada_library_v2\boards\MicroBit\obj\zfp_lib_Debug\
   --   -LC:\gnat\2020-arm-elf\arm-eabi\lib\gnat\zfp-cortex-m4f\adalib\
   --   -static
   --   -lgnat
--  END Object file/option list   

end ada_main;
