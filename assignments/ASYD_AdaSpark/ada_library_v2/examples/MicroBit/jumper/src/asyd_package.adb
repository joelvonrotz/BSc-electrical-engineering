package body asyd_package is
   
   function sqrt_float(A : Float) return Float is
    Approximation : Float := A / 2.0; -- Initial guess
    Epsilon : constant Float := 0.01; -- Desired precision
    Next_Approximation : Float := 0.0;
   begin
      loop
         Next_Approximation := (Approximation + A / Approximation) / 2.0;
         if Next_Approximation - Approximation < 0.0 then
            if Approximation - Next_Approximation < Epsilon then
               exit;
            end if;
         end if;
         if Next_Approximation - Approximation >= 0.0 then
            if Next_Approximation - Approximation < Epsilon then
               exit;
            end if;
         end if;
         Approximation := Next_Approximation;
      end loop;

      return Approximation;
   end sqrt_float;

   
   -- Function Return the sqrt of the Integer Value given * 10
   -- e.g. sqrt(144) will return 120
   -- Function has potential Errors!
   function sqrt_int(number:Integer) return Integer is
      A : Integer := 0;
      Approximation : Integer := 200; -- Initial guess
      Next_Approximation : Integer := 0;
   begin 
      --if number <= 2147 then
      if number <= 800000 then
         A := number * 10;
         loop
            Next_Approximation := Approximation;
            Approximation := (Next_Approximation + A*10 / Next_Approximation) / 2;
            exit when abs(Next_Approximation - Approximation) <= 1;
         end loop;
         return Approximation;
      else
         return -1; -- Error
      end if;
   end sqrt_int;

      
   function test(b: Float) return Float is
      my_var : Float := 5.0;
   begin
      
         return (my_var + b);
      
   end test;

end asyd_package;
