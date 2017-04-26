
with Ada.Text_IO, direct_io; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Unchecked_Conversion;
with hashB; use hashB;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure test is
   
begin
--     put_line("QA:");
--     hashB.mainMem("Words200D16.txt", 128, 0.40, linear, yours);
     
--    put_line("QB:");
--    hashB.mainMem("Words200D16.txt", 128, 0.87, random, yours);
--    hashB.mainMem("Words200D16.txt", 128, 0.87, random, mine);
--    
--    put_line("QC:");
--    hashB.mainMem("Words200D16.txt", 128, 0.40, random, mine);
--    hashB.mainMem("Words200D16.txt", 128, 0.87, random, mine);

   --hashB.file ("Words200D16.txt", "test.txt", 128, 0.40, linear, yours);
   hashB.slingHash ("Words200D16.txt", "test.txt", 128, 0.87, linear, yours, file);
end test;

