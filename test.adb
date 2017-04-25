
with Ada.Text_IO, direct_io; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Unchecked_Conversion;
with hashB; use hashB;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure test is
   subtype outStr is String(1..25);
   package outIO is new Direct_IO(outStr);
   use outIO;
   storage : outIO.File_Type;
   nullString : outStr := "                   0   0 ";
   rec : hashB.hashRecord := ("1234567890123456", 112, 10);
   s1 : Unbounded_String := To_Unbounded_String(Integer'Image(rec.probes));
begin
--     put_line("Part A:");
--     hashB.mainMem("Words200D16.txt", 128, 0.40, linear, yours);
     
--    put_line("Part B:");
--    hashB.mainMem("Words200D16.txt", 128, 0.87, random, yours);
--    hashB.mainMem("Words200D16.txt", 128, 0.87, random, mine);
--    
--    put_line("Part C:");
--    hashB.mainMem("Words200D16.txt", 128, 0.40, random, mine);
--    hashB.mainMem("Words200D16.txt", 128, 0.87, random, mine);

   -- hashB.file ("Words200D16.txt", "test.txt", 128, 0.40, linear, yours);
   Create(storage, inout_file, "test.txt");
   Reset(storage);
   for i in 10..15 loop
      nullstring(1..3) := Integer'Image(i);
      outIO.Write(storage, nullString, outIO.Count(i));
         end loop;
         
   for i in outIO.positive_count range 10..15 loop
      outIO.Read(storage, nullString, i);
      put_line(nullString);
   end loop;

   put(to_string(rec));New_Line;
   rec := to_record("hash567890123456  10   2 ");
   put(rec.Item); put(rec.loc); put(rec.probes);

end test;

