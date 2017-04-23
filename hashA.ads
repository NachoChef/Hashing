with Ada.Text_IO; use Ada.Text_IO;
with Direct_IO, Ada.Unchecked_Conversion;

generic
   type Element is private;
   with procedure myWrite(file : File_Type; Item : element; Location : Direct_IO.Count,  );
   with procedure myRead(file : File_Type; Item : element; Location : Direct_IO.Count, );
   with function Slice(Item : Element) return String;
   with function getKey(Item : Element) return Integer;
package hashA is
   package hashIO is new Direct_IO(Element);
   use hashIO;
   package fIO is new Float_IO(Float);
   use fIO;
   type Unsigned_64 is mod 2**64;
   function e2Uns is new Ada.Unchecked_Conversion(Element, Unsigned_64);
   function uns2Int is new Ada.Unchecked_Conversion(Element, Unsigned_64);
   procedure getAvg(input : hashIO.File_Type; myTable : hashTable; lower : Integer; upper : Integer; probeType : probe; hashType : hash);
   procedure getTheor (input : hashIO.File_Type; myTable : hashTable; probeType : probe);
end hashA;