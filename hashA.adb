package hashA is
   procedure slingHash(inFile : String; outFile : String; size : Integer; percentFull : Float; hashType : hash) is
      input : hashIO.File_Type;
      storage : storageIO.File_Type;
   begin
      Open(input, in_file, inFile);
      declare
         nullRec : hashRecord := ("                ", 0, 0, null);
      begin
         Create(storage, inout_file, outFile);
         storageIO.Reset(storage);
         --initialize values
         for i in storageIO.positive_count 1..size loop
            outIO.Write(storage, nullString, i);
         end loop;
         
         for i in 2..UB+1 loop   --skipping first entry in file
            declare
               hRec : hashRecord;
               temp : hRead;
               offset : Integer := 0;
               R : Integer := 1;
               div : Integer := 2 ** (Integer(Log(Base => 2.0, X => Float(size))) + 2);
            begin
               Read(input, temp, hashIO.Count(i));
               hRec.Item := temp(1..16);
               if hashType = yours then
                  hRec.loc := getKey(hRec.Item);
               else
                  hRec.loc := myKey(hRec.Item, size);
               end if;
               -------------------------
               loop
                  outIO.Read(storage, tOut, outIO.Count(hRec.loc));
                  hRec.probes := hRec.probes + 1;
                  exit when tOut = nullString;
                  if probeType = LINEAR then
                     offset := offset + 1;
                  else
                     R := (R * 5) mod div;
                     offset := offset + (R/4);
                  end if;
                  --fix
                  storageIO.Write(storage, to_string(hRec), storageIO.Count(((hRec.loc + offset) mod size) + 1));
               end loop;
            end;
         end loop; 
         
         for i in 1..size loop
            outIO.Read(storage, tOut, outIO.Count(i));
            if tOut /= nullString then
               put(Integer'Image(i) & " is "); put(tOut(1..16)); put("Original location:" & tOut(18..20));put("     Probes:" & tOut(22..24)); New_Line;
            else
               put_line(Integer'Image(i) & " is NULL");
            end if;
         end loop; 
         -- getAvg(input, myTable, 2, 31, probeType, hashType);
--          getAvg(input, myTable, UB-30, UB, probeType, hashType); 
--          getTheor(input, myTable, probeType); New_Line;
      end;
      Close(input);



end hashA;