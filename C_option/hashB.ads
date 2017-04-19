with Ada.Text_IO; use Ada.Text_IO;
with direct_io;
with Ada.Unchecked_Conversion;

package hashB is
   package fIO is new Float_IO(Float);
   use fIO;
   subtype hRead is String(1..18);--handles line return
   subtype hElement is String(1..16); 
   subtype slice is String(1..2);
   subtype mySlice is String(1..8);
   type Unsigned_64 is mod 2**64;
   type hashRecord is record
      Item : hElement;
      loc : Integer;
      probes : Integer := 1;
   end record;
   package hashIO is new Direct_IO(hRead);
   use hashIO;
   type hashTable is array(Integer range <>) of hashRecord;
   
   type probe is (linear, random);
   type hash is (mine, yours);
   function str2Uns is new Ada.Unchecked_Conversion(slice, Unsigned_64);
   function mystr2Uns is new Ada.Unchecked_Conversion(mySlice, Unsigned_64);
   function char2Uns is new Ada.Unchecked_Conversion(character, Unsigned_64);
   function uns2Int is new Ada.Unchecked_Conversion(Unsigned_64, Integer);
   function Int2Uns is new Ada.Unchecked_Conversion(Integer, Unsigned_64);
   function cnt2Int is new Ada.Unchecked_Conversion(hashIO.Count, Integer);
   function int2Cnt is new Ada.Unchecked_Conversion(Integer, hashIO.Count);
   procedure mainMem (inFile : String; size : Integer; percentFull : Float; probeType : probe; hashType : hash);
   procedure relFile (inFile : String; outFile : String);
   procedure storeItem (Item : hElement; file : hashIO.File_Type);
   procedure getAvg(input : hashIO.File_Type; myTable : hashTable; lower : Integer; upper : Integer; probeType : probe; hashType : hash);
   procedure getTheor (input : hashIO.File_Type; myTable : hashTable; probeType : probe);
   function getKey (Item : hElement) return Integer;
   function myKey (Item : hElement; TS : Integer) return Integer;
end hashB;