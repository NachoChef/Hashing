--with hashB; 
with Ada.Text_IO, direct_io; use Ada.Text_IO;
with Ada.Unchecked_Conversion;
with hashB;

procedure test is
begin
   hashB.mainMem("Words200D16.txt", "out.txt");
   -- Open(file, in_file, "Words200D16.txt");
--    for i in 1..30 loop
--       Read(file, temp, int2Cnt(i));
--       put_line(temp(1..16));
--    end loop;
end test;

-- procedure Read
--   (File : in File_Type;
--    Item : out Element_Type;
--    From : in Positive_Count);