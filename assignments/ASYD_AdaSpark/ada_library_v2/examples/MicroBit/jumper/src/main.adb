with LSM303; use LSM303;

with MicroBit.Display;
with MicroBit.Accelerometer;
with MicroBit.Console;
with MicroBit.IOs;
with MicroBit.Time;
use MicroBit;
with asyd_package; use asyd_package;


procedure Main is

   Data : LSM303.All_Axes_Data;
   FreeFall : Integer;
   FreeFallOccurance : Integer := 0;
   Blinki : Boolean := False;
   FreeFell : Boolean := False;
   bla : Integer; -- String to hold the converted float
   begin
   Console.Put_Line ("Jumper - starting up ..");
   -- control for the sqrt function
   bla := sqrt_int(958);
   Console.Put_Line(bla'Img);


   loop
      --  Read the accelerometer data
      Data := Accelerometer.Data;
      FreeFall := sqrt_int((Integer(Data.X**2))+(Integer(Data.Y**2))+(Integer(Data.Z**2)));
      Console.Put_Line("Free Fall Sqrt(x)*10" & FreeFall'Img);

      --  Print the data on the serial port
      -- Console.Put_Line ("X:" & Data.X'Img & ASCII.HT &
      --                  "Y:" & Data.Y'Img & ASCII.HT &
      --                  "Z:" & Data.Z'Img );

      -- GPIO Control
      -- FreeFall == 100   ist eigentlich nur 10
      if (FreeFell = False) then
         if FreeFall < 1000 then
            Console.Put_Line("Free Fall occured");
            Display.Clear;
            Display.Display ('T');
            FreeFallOccurance := (FreeFallOccurance + 1);
         elsif FreeFallOccurance > 0 then
            FreeFallOccurance := (FreeFallOccurance - 1); -- some errors can occur when it does freeFall gets subtracted 1
         else
            Display.Clear;
            FreeFallOccurance := 0;
         end if;
      end if;

      if (FreeFallOccurance > 100) and (FreeFell = False) then
         Console.Put_Line("Activate Motor!");
         Display.Clear;
         Display.Display ('X');
         FreeFell := True;
      end if;


      --  Turn on the LED connected to pin 0
      MicroBit.IOs.Set (3, True);

      --  Wait 500 milliseconds
      -- MicroBit.Time.Delay_Ms (500);

      --  Clear the LED matrix
      --Display.Clear;

      -- Blinki To check if the board still works
      if Blinki then
         Display.Set(4,2);
         Blinki := False;
      else
         Display.Clear(4,2);
         Blinki := True;
      end if;


      Time.Sleep (1);
   end loop;
end Main;


