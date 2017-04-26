with Ada.Text_IO; use Ada.Text_IO;
with Direct_IO, Ada.Unchecked_Conversion;

package hashA is
   subtype slice is String(1..2);
   subtype hashElement is String(1..16);
   subtype hRead is String(1..18);  --to handle line returns, etc
   subtype foldStr is String(1..8);
   type hashRecord;
   type hashPt is access hashRecord;
   type hashRecord is record
      Item : hashElement;
      loc : Integer;
      probes : Integer;
      next : hashPt;
   end record;
   
   package hashIO is new Direct_IO(hRead);
   use hashIO;
   package storageIO is new Direct_IO(hashPt);
   use storageIO;
   package fIO is new Float_IO(Float);
   use fIO;
   
   type hash is (mine, yours);
   
   type Unsigned_64 is mod 2**64;
   function s2Uns is new Ada.Unchecked_Conversion(slice, Unsigned_64);
   function c2Uns is new Ada.Unchecked_Conversion(Character, Unsigned_64);
   function uns2Int is new Ada.Unchecked_Conversion(Unsigned_64, Integer);
   function f2Uns is new Ada.Unchecked_Conversion(foldStr, Unsigned_64);
   procedure slingHash(inFile : String; outFile : String; size : Integer; percentFull : Float; hashType : hash);
   procedure getAvg(input : hashIO.File_Type; storage : storageIO.File_Type; size : Integer; lower : Integer; upper : Integer; hashType : hash);
   procedure getTheor(input : hashIO.File_Type; storage : storageIO.File_Type; size : Integer);
   function getKey (Item : hashElement) return Integer;
   function myKey (Item : hashElement; TS : Integer) return Integer;
end hashA;