with Ada.Text_IO, direct_io; use Ada.Text_IO;
with hash; use hash;

procedure main is
   
begin
   put_line("Question A:");
--    hash.slingHash ("Words200D16.txt", "null", 128, 0.40, linear, yours, memory);
   hash.slingHash ("Words200D16.txt", "QA", 128, 0.40, linear, yours, file);
--      
--    put_line("Question B:");
--    hash.slingHash ("Words200D16.txt", "null", 128, 0.87, linear, yours, memory);
--    hash.slingHash ("Words200D16.txt", "QB", 128, 0.84, linear, yours, file);
--   
--    put_line("Question C:");
--    hash.slingHash ("Words200D16.txt", "null", 128, 0.40, random, yours, memory);
--    hash.slingHash ("Words200D16.txt", "null", 128, 0.87, random, yours, memory);
--    hash.slingHash ("Words200D16.txt", "QC_1", 128, 0.40, random, yours, file);
--    hash.slingHash ("Words200D16.txt", "QC_2", 128, 0.87, random, yours, file);
-- 
--    put_line("Question E:");
--    hash.slingHash ("Words200D16.txt", "null", 128, 0.40, linear, mine, memory);
--    hash.slingHash ("Words200D16.txt", "null", 128, 0.87, linear, mine, memory);
--    hash.slingHash ("Words200D16.txt", "null", 128, 0.40, random, mine, memory);
--    hash.slingHash ("Words200D16.txt", "null", 128, 0.87, random, mine, memory);
--    hash.slingHash ("Words200D16.txt", "QE_1", 128, 0.40, linear, mine, file);
--    hash.slingHash ("Words200D16.txt", "QE_2", 128, 0.87, linear, mine, file);
--    hash.slingHash ("Words200D16.txt", "QE_3", 128, 0.40, random, mine, file);
--    hash.slingHash ("Words200D16.txt", "QE_4", 128, 0.87, random, mine, file);
end main;