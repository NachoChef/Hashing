with Ada.Text_IO; use Ada.Text_IO;
with direct_io;
with Ada.Unchecked_Conversion;

package hashB is
   subtype hRead is String(1..18);--handles line return
   subtype hElement is String(1..16); 
   subtype slice is String(1..2);
   type Unsigned_64 is mod 2**64;
   type hashRecord is record
      Item : hElement;
      loc : Integer;
      probes : Integer := 1;
   end record;
   package hashIO is new Direct_IO(hRead);
   use hashIO;
   type hashTable is array(Positive range <>) of hashRecord;
   
   function str2Uns is new Ada.Unchecked_Conversion(slice, Unsigned_64);
   function char2Uns is new Ada.Unchecked_Conversion(character, Unsigned_64);
   function uns2Int is new Ada.Unchecked_Conversion(Unsigned_64, Integer);
   function cnt2Int is new Ada.Unchecked_Conversion(hashIO.Count, Integer);
   function int2Cnt is new Ada.Unchecked_Conversion(Integer, hashIO.Count);
   procedure mainMem (inFile : String; outFile : String);
   procedure relFile (inFile : String; outFile : String);
   function getKey(Item : hElement) return Integer;
   procedure storeItem (Item : hElement; file : hashIO.File_Type);
   function getItem (Item : hElement; file : hashIO.File_Type) return Integer;
   procedure getAvg(input : hashIO.File_Type; myTable : hashTable; lower : Integer; upper : Integer);
   procedure getTheor (input : hashIO.File_Type; myTable : hashTable);
end hashB;
   
   
--use the text file for input