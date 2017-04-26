with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
package body hashA is
   procedure slingHash(inFile : String; outFile : String; size : Integer; percentFull : Float; hashType : hash) is
      input : hashIO.File_Type;
      storage : storageIO.File_Type;
   begin
      Open(input, in_file, inFile);
      declare
         nullRec : hashPt := new hashRecord'("                ", 0, 0, null);
         T : hashPt;   --temp reads
      begin
         Create(storage, inout_file, outFile);
         storageIO.Reset(storage);
         --initialize values
         for i in 1..size loop
            storageIO.Write(storage, nullRec, storageIO.Count(i));
         end loop;
         
         for i in 2..31 loop   --skipping first entry in file
            declare
               T : hashPt := new hashRecord;
               temp : hRead;
               R : Integer := 1;
               div : Integer := 2 ** (Integer(Log(Base => 2.0, X => Float(size))) + 2);
            begin
               Read(input, temp, hashIO.Count(i));
               T.Item := temp(1..16);
               if hashType = yours then
                  T.loc := getKey(T.Item);
               else
                  T.loc := myKey(T.Item, size);
               end if;
               loop
                  storageIO.Read(storage, T, storageIO.Count(T.loc));
                  T.probes := T.probes + 1;
                  exit when T = nullRec;
                  --fix
                  storageIO.Write(storage, T, storageIO.Count(T.loc));
               end loop;
            end;
         end loop; 
         
         for i in 1..size loop
            storageIO.Read(storage, T, storageIO.Count(i));
            if T /= nullRec then
               put(Integer'Image(i) & " is "); put(T.Item); put("Original location:" & Integer'Image(T.loc));put("     Probes:" & Integer'Image(T.probes)); New_Line;
            else
               put_line(Integer'Image(i) & " is NULL");
            end if;
         end loop; 
         -- getAvg(input, myTable, 2, 31, probeType, hashType);
--          getAvg(input, myTable, UB-30, UB, probeType, hashType); 
--          getTheor(input, myTable, probeType); New_Line;
      end;
      Close(input);
      Close(storage);
   end slingHash;

   function getKey (Item : hashElement) return Integer is
      temp : Unsigned_64;
   begin
      --shift left 8 bits
      temp := ((s2Uns(Item(1..2)) + s2Uns(Item(6..7)))*256);
      temp := temp + c2Uns(Item(13));
      --first 8 bits is now above char
      temp := temp mod 128;
      --extract first 8 bits
      return uns2Int(temp);
   end getKey;
   
   function myKey (Item : hashElement; TS : Integer) return Integer is
      temp : Unsigned_64;
   begin
      temp := f2Uns(Item(1..8)) * f2Uns(Item(9..16)); --square
      temp := temp XOR 9999999900000001;  --scramble (this number is prime)
      temp := temp / 100000;    --shift dec integer right 5 places
      return uns2Int(temp mod Unsigned_64(TS));  --extract first N bytes, where Log2N = TS
   end myKey;
   
   procedure getAvg (input : hashIO.File_Type; storage : storageIO.File_Type; size : Integer; lower : Integer; upper : Integer; hashType : hash) is
      min : Integer := 1000;  --reasonably high for size
      max : Integer := 1;     --lowest possible
      avg : Float := 0.0;  
      div : Float := Float(upper-lower+1);
   begin
      for i in lower..upper loop
         declare
            T, T2 : hashPt;
            temp : hRead;
            offset : Integer := 0;
            R : Integer := 1;
            divisor : Integer := 2 ** (Integer(Log(Base => 2.0, X => Float(size))) + 2);

         begin
            hashIO.Read(input, temp, hashIO.Count(i));
            T.Item := temp(1..16);
            if hashType = yours then
               T.loc := getKey(T.Item);
            else
               T.loc := myKey(T.Item, size);
            end if;
            --fix reading pls
            storageIO.Read(storage, T2, storageIO.Count(T.loc));
            loop
               exit when T.Item = T2.Item;
               T.probes := T.probes + 1;
               T2 := T2.next;
            end loop;
            if T.probes < min then
               min := T.probes;
            elsif T.probes > max then
               max := T.probes;
            end if;
            avg := avg + (Float(T.probes)/div);
         end;
      end loop;
      put_line("----------------");
      put_line("Stats for" & Integer'Image(lower) & " to" & Integer'Image(upper));
      put_line("Min:" & Integer'Image(min));
      put_line("Max:" & Integer'Image(max));
      put_line("Avg:" & Integer'Image(Integer(Float'Unbiased_Rounding(avg))));
   end getAvg;
   
   procedure getTheor (input : hashIO.File_Type; storage : storageIO.File_Type; size : Integer) is
      keys : integer := 0;
      alpha, E : Float;
      T : hashPt := new hashRecord;
   begin
      for i in 1..size loop
         storageIO.Read(storage, T, storageIO.Count(i));
         if T.Item /= "                " then
            keys := keys + 1;                  
         end if;
      end loop;
      alpha := (Float(keys) / Float(size));
      --calculate that bad boy
      E := 1.0 + alpha / 2.0;
      put_line("----------------");
      put_line("Keys:" & Integer'Image(keys));
      put("Load level: "); fIO.put(Item => alpha * 100.0, Fore => 2, Aft => 2, Exp => 0);put("%"); New_Line;
      put("Expected average probes:"); fIO.put(Item => E, Fore => 2, Aft => 2, Exp => 0); New_Line;
   end getTheor;
end hashA;