with Ada.Text_IO; use Ada.Text_IO;
with Direct_IO, Ada.Unchecked_Conversion;

package hashA is
   subtype hashElement is String(1..16);
   type hashRecord;
   type hashPt is access hashRecord;
   type hashRecord is record
      Item : hashElement;
      loc : Integer;
      probes : Integer;
      next : hashPt;
   end record;
   
   package hashIO is new Direct_IO(hashElement);
   use hashIO;
   package storageIO is new Direct_IO(hashRecord);
   use storageIO;
   package fIO is new Float_IO(Float);
   use fIO;
   
   type hash is (mine, yours);
   
   type Unsigned_64 is mod 2**64;
   function e2Uns is new Ada.Unchecked_Conversion(hashElement, Unsigned_64);
   function uns2Int is new Ada.Unchecked_Conversion(hashElement, Unsigned_64);
   procedure slingHash(inFile : String; outFile : String; size : Integer; percentFull : Float; hashType : hash);
   procedure getAvg(input : hashIO.File_Type; storage : storageIO.File_Type; lower : Integer; upper : Integer; hashType : hash);
   procedure getTheor(input : hashIO.File_Type; storage : storageIO.File_Type);
end hashA;