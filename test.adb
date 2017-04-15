--with hashB; 
with Ada.Text_IO, direct_io; use Ada.Text_IO;
with Ada.Unchecked_Conversion;
with hashB;

procedure test is
begin
   -- put_line("Part A:");
--    hashB.mainMem("Words200D16.txt", 128, 0.40, hashB.linear);
--    
--    put_line("Part B:");
--    hashB.mainMem("Words200D16.txt", 128, 0.87, hashB.linear);
   
   put_line("Part C:");
   hashB.mainMem("Words200D16.txt", 128, 0.40, hashB.random);
   hashB.mainMem("Words200D16.txt", 128, 0.87, hashB.random);
end test;