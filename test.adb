--with hashB; 
with Ada.Text_IO, direct_io; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Unchecked_Conversion;
with hashB; use hashB;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure test is
   type growthSpace is array(Integer range <>) of Integer;
   subtype slice is String(1..2);
   type Unsigned_64 is mod 2**64;
   function str2Long is new Ada.Unchecked_Conversion(slice, Long_integer);
   function str2Uns is new Ada.Unchecked_Conversion(slice, Unsigned_64);
   function long2Int is new Ada.Unchecked_Conversion(Long_integer, Integer);
   function uns2Int is new Ada.Unchecked_Conversion(Unsigned_64, Integer);
begin
--     put_line("Part A:");
--     hashB.mainMem("Words200D16.txt", 128, 0.40, linear, yours);
     
   put_line("Part B:");
   hashB.mainMem("Words200D16.txt", 128, 0.87, random, yours);
   hashB.mainMem("Words200D16.txt", 128, 0.87, random, mine);
--    
--    put_line("Part C:");
--    hashB.mainMem("Words200D16.txt", 128, 0.40, random, mine);
--    hashB.mainMem("Words200D16.txt", 128, 0.87, random, mine);
end test;

hashTable