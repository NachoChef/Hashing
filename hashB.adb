with Ada.Direct_IO;
package body hashB is

   procedure mainMem (inFile : String; outFile : String) is
      input : hashIO.File_Type;
      output : Ada.Text_IO.File_Type;
   begin
      Open(input, in_file, inFile);
      Reset(input);
      declare
         nullRec : hashRecord := (Item => "                ",  loc => 0, probes => 0);
         myTable : hashTable(1..128) := (others => nullRec);
         
      begin
         for i in 1..51 loop
            declare
               hRec : hashRecord;
               temp : hRead;
            begin
               Read(input, temp, int2Cnt(i));
               hRec.Item := temp(1..16);
               hRec.loc := getKey(hRec.Item);
               while myTable(hRec.loc + (hRec.probes - 1)).Item /= nullRec.Item loop
                  hRec.probes := hRec.probes + 1;
               end loop;
               myTable(hRec.loc+hRec.probes-1) := hRec;
            end;
         end loop; 
         
         for i in 1..128 loop
            if myTable(i).Item /= nullRec.Item then
               put(Integer'Image(i) & " is "); put(myTable(i).Item); put("Probes:" & Integer'Image(myTable(i).probes)); New_Line;
            else
               put_line(Integer'Image(i) & " is NULL");
            end if;
         end loop; 
         getAvg(input, myTable, 1, 30);
         getAvg(input, myTable, 21, 51); 
         getTheor(input, myTable);
      end;
   end mainMem;
   
   procedure getAvg (input : hashIO.File_Type; myTable : hashTable; lower : Integer; upper : Integer) is
      min : Integer := myTable'Last+1;
      max : Integer := 1;
      avg : Float := 0.0;
   begin
      for i in lower..upper loop
         declare
            hRec : hashRecord;
            temp : hRead;
         begin
            Read(input, temp, int2Cnt(i));
            hRec.Item := temp(1..16);
            hRec.loc := getKey(hRec.Item);
            while myTable(hRec.loc + (hRec.probes - 1)).Item /= hRec.Item loop
               hRec.probes := hRec.probes + 1;
            end loop;
            if hRec.probes < min then
               min := hRec.probes;
            elsif hRec.probes > max then
               max := hRec.probes;
            end if;
            avg := avg + (Float(hRec.probes)/Float(upper-lower+1));
         end;
      end loop;
      put_line("Stats for" & Integer'Image(lower) & " to" & Integer'Image(upper));
      put_line("Min:" & Integer'Image(min));
      put_line("Max:" & Integer'Image(max));
      put_line("Avg:" & Integer'Image(Integer(Float'Unbiased_Rounding(avg))));
   end getAvg;
   
   procedure getTheor (input : hashIO.File_Type; myTable : hashTable) is
      keys : integer := 0;
      TS : integer := myTable'First - myTable'Last + 1;
      alpha, E : Float;
   begin
      for i in myTable'Range loop
         if myTable(i).Item /= "                " then
            keys := keys + 1;                  
         end if;
      end loop;
      alpha := Float(keys) / Float(TS);
      E := (1.0 - alpha / 2.0) / (1.0 - alpha);
      put_line("Keys:" & Integer'Image(keys));
      put_line("Load level:" & Float'Image(alpha));
      put_line("Expected average probes:" & Float'Image(E));
   end getTheor;
      
   procedure relFile (inFile : String; outFile : String) is
      input, output : Ada.Text_IO.File_Type;
      hashTable : hashIO.File_Type;
   begin
      null;
   end relFile;

-----------------------------------------------------------------
   function getKey (Item : hElement) return Integer is
      temp : Unsigned_64;
   begin
      temp := ((str2Uns(Item(1..2)) + str2Uns(Item(6..7)))*256);
      temp := temp + char2Uns(Item(13));
      temp := temp mod 128;
      return uns2Int(temp);
   end getKey;
   
   procedure storeItem (Item : hElement; file : hashIO.File_Type) is
      myRecord : hashRecord := (Item, getKey(Item), 1); --initialization
      temp : hashRecord;
   begin
      --if Read(file, 
      --Write(file, myRecord, getKey(Item));
      null;
   end;
   
   function getItem (Item : hElement; file : hashIO.File_Type) return Integer is
      result : hashRecord;
      probes : integer := 0;
      loc : hashIO.Count := int2Cnt(getKey(Item));
   begin
      loop
         exit when result.Item = Item;
         --Read(file, result, loc + probes);
         probes := probes + 1;
      end loop; 
      return cnt2Int(loc);   
   end getItem;
   
end hashB;