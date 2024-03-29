--Justin Jones
--COSC 3319.01 Spring 2017
--Lab 4
--
--'A' Option 1
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body hash is

   procedure slingHash(inFile : String; outFile : String; size : Integer; 
                       percentFull : Float; probeType : probe; hashType : hash; 
                       loc : implementation) is
   begin
      put_line("Hash: " & hash'Image(hashType));
      put_line("Probe: " & probe'Image(probeType));
      if loc = memory then
         put_line("Location: main memory");
         mainMem (inFile, size, percentFull, probeType, hashType);
      else
         put_line("Location: " & outFile);
         file (inFile, outFile, size, percentFull, probeType, hashType);
      end if;
   end slingHash;

   procedure mainMem (inFile : String; size : Integer; percentFull : Float; 
                      probeType : probe; hashType : hash) is
      input : hashIO.File_Type;
      UB : Integer := Integer(Float'Floor(Float(size) * percentFull));     
   begin
      Open(input, in_file, inFile);
      Reset(input);
      declare
         nullRec : hashRecord := (Item => "                ", loc => 0, probes => 0);
         myTable : hashTable(0..size-1) := (others => nullRec);
      begin
         for i in 2..UB+1 loop
            declare
               hRec : hashRecord;
               temp : hRead;
               offset : Integer := 0;
               R : Integer := 1;
               div : Integer := 2**(Integer(Log(Base => 2.0, X => Float(size))) + 2);
            begin
               Read(input, temp, hashIO.Count(i));
               hRec.Item := temp(1..16);
               if hashType = yours then
                  hRec.loc := getKey(hRec.Item);
               else
                  hRec.loc := myKey(hRec.Item, size);
               end if;
               
               while myTable((hRec.loc + offset) mod size).Item /= nullRec.Item loop
                  if probeType = LINEAR then
                     offset := offset + 1;
                  else
                     R := (R * 5) mod div;
                     offset := R/4;
                  end if;
                  
                  hRec.probes := hRec.probes + 1;
               end loop;
               myTable((hRec.loc + offset) mod size) := hRec;
            end;
         end loop; 
         
         for i in 0..size-1 loop
            if myTable(i).Item /= nullRec.Item then
               put(Integer'Image(i) & " is "); put(myTable(i).Item); 
               put("Original location:" & Integer'Image(myTable(i).loc));
               put("     Probes:" & Integer'Image(myTable(i).probes)); New_Line;
            else
               put_line(Integer'Image(i) & " is NULL");
            end if;
         end loop; 
         getAvg(input, eFile, myTable, 2, 31, size, probeType, hashType, memory);
         getAvg(input, eFile, myTable, UB-29, UB, size, probeType, hashType, memory); 
         getTheor (size, UB, probeType); New_Line;
      end;
      Close(input);
   end mainMem;   
   
   procedure file (inFile : String; outFile : String; size : Integer; 
                   percentFull : Float; probeType : probe; hashType : hash) is
      input : hashIO.File_Type;
      storage : outIO.File_Type;
      UB : Integer := Integer(Float'Floor(Float(size) * percentFull));
      T : hashRecord;    -- temp out
      loc : Integer;
   begin
      Open(input, in_file, inFile);
      declare
         nullRec : hashRecord := ("                ", 0, 0);
      begin
         Create(storage, inout_file, outFile);
         for i in 1..size loop
            outIO.Write(storage, nullRec, outIO.Count(i));
         end loop;
         
         for i in 2..UB+1 loop
            declare
               hRec : hashRecord;
               temp : hRead;
               offset : Integer := 0;
               R : Integer := 1;
               div : Integer := 2**(Integer(Log(Base => 2.0, X => Float(size))) + 2);
            begin
               hashIO.Read(input, temp, hashIO.Count(i));
               hRec.Item := temp(1..16);  --slice out item
               if hashType = yours then
                  hRec.loc := getKey(hRec.Item);
               else
                  hRec.loc := myKey(hRec.Item, size);
               end if;
               --searching for unused space
               loop
                  loc := (hRec.loc + offset) mod size;
                  if loc = 0 then   --fix wrap around, 1 based
                     loc := 64;
                  end if;
                  outIO.Read(storage, T, outIO.Count(loc));
                  exit when T = nullRec;
                  hRec.probes := hRec.probes + 1;
                  if probeType = LINEAR then
                     offset := offset + 1;
                  else
                     R := (R * 5) mod div;
                     offset := R/4;
                  end if;
               end loop;
               
               outIO.Write(storage, hRec, outIO.Count(loc));
            end;
         end loop; 
         
         for i in 1..size loop
            --reading to T to print
            outIO.Read(storage, T, outIO.Count(i));
            if T /= nullRec then
               put(Integer'Image(i) & " is "); put(T.Item); 
               put("Original location:" & Integer'Image(T.loc));
               put("     Probes:" & Integer'Image(T.probes)); New_Line;
            else
               put_line(Integer'Image(i) & " is NULL");
            end if;
         end loop; 
         getAvg(input, storage, eTable, 2, 31, size, probeType, hashType, file);
         getAvg(input, storage, eTable, UB-29, UB, size, probeType, hashType, file); 
         getTheor (size, UB, probeType); New_Line;
         Close(storage);
      end;
      Close(input);
   end file;   

   procedure getAvg (input : hashIO.File_Type; storage : outIO.File_Type; 
                    myTable : hashTable; lower : Integer; upper : Integer; 
                    size : Integer; probeType : probe; hashType : hash;
                    location : implementation) is
      min : Integer := 1000;
      max : Integer := 1;
      avg : Float := 0.0;
      div : Float := Float(upper-lower+1);
   begin
      for i in lower..upper loop
         declare
            T, T2: hashRecord;
            temp : hRead;
            offset, loc : Integer := 0;
            R : Integer := 1;
            divisor : Integer:=2**(Integer(Log(Base => 2.0, X => Float(size))) + 2);
         begin
            Read(input, temp, hashIO.Count(i));
            T.Item := temp(1..16);
            if hashType = yours then
               T.loc := getKey(T.Item);
            else
               T.loc := myKey(T.Item, size);
            end if;
            if location = file then
               loop
                  loc := (T.loc + offset) mod size;
                  if loc = 0 then   --fix wrap around, 1 based
                     loc := 64;
                  end if;
                  outIO.Read(storage, T2, outIO.Count(loc));
                  exit when T2.Item = T.Item;
                  T.probes := T.probes + 1;
                  if probeType = LINEAR then
                     offset := offset + 1;
                  else
                     R := (R * 5) mod divisor;
                     offset := R/4;
                  end if;
               end loop;
            else
               while myTable((T.loc + offset) mod size).Item /= T.Item loop
                  if probeType = LINEAR then
                     offset := offset + 1;
                  else
                     R := (R * 5) mod divisor;
                     offset := R/4;
                  end if;
                  T.probes := T.probes + 1;
               end loop;
            end if;
            if T.probes < min then
               min := T.probes;
            elsif T.probes > max then
               max := T.probes;
            end if;
            avg := avg + (Float(T.probes) / div);
         end;
      end loop;
      put_line("----------------");
      put_line("Stats for" & Integer'Image(lower) & " to" & Integer'Image(upper));
      put_line("Min:" & Integer'Image(min));
      put_line("Max:" & Integer'Image(max));
      put("Avg:"); fIO.put(Item => avg, Fore => 3, Aft => 2, Exp => 0); New_Line;
   end getAvg;
   
   procedure getTheor (size : Integer; keys : Integer; probeType : probe) is
      alpha, E : Float;
   begin
      alpha := (Float(keys) / Float(size));
      if probeType = LINEAR then
         E := (1.0 - alpha / 2.0) / (1.0 - alpha);
      else
         E := -(1.0 / alpha) * (Log(1.0 - alpha));
      end if;
      put_line("----------------");
      put_line("Keys:" & Integer'Image(keys));
      put("Load level: "); 
      fIO.put(Item => alpha * 100.0, Fore => 2, Aft => 2, Exp => 0); put("%"); 
      New_Line;
      put("Expected average probes:"); 
      fIO.put(Item => E, Fore => 2, Aft => 2, Exp => 0); New_Line;
   end getTheor;

   function getKey (Item : hElement) return Integer is
      temp : Unsigned_64;
   begin
      --shift left 8 bits
      temp := ((str2Uns(Item(1..2)) + str2Uns(Item(6..7)))*256);
      temp := temp + char2Uns(Item(13));
      --first 8 bits is now above char
      temp := temp mod 128;
      --extract first 8 bits
      return uns2Int(temp);
   end getKey;
   
   function myKey (Item : hElement; TS : Integer) return Integer is
      temp : Unsigned_64;
   begin
      temp := mystr2Uns(Item(1..8)) * mystr2Uns(Item(9..16)); --square
      temp := temp / 2**12; 
      return uns2Int(temp mod int2Uns(TS));  --extract first N bytes where Log2N = TS
   end myKey;
   
end hash;