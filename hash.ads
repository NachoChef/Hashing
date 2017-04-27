--Justin Jones
--COSC 3319.01 Spring 2017
--Lab 4
--
--'A' Option 1
with Ada.Text_IO; use Ada.Text_IO;
with direct_io;
with Ada.Unchecked_Conversion;

package hash is
   package fIO is new Float_IO(Float);
   use fIO;
   subtype hRead is String(1..18);--handles line return
   subtype hElement is String(1..16); 
   subtype slice is String(1..2);
   subtype mySlice is String(1..8);
   subtype outStr is String(1..25);
   type Unsigned_64 is mod 2**64;
   type hashRecord is record
      Item : hElement;
      loc : Integer;
      probes : Integer := 1;
   end record;
   package hashIO is new Direct_IO(hRead);
   use hashIO;
   package outIO is new Direct_IO(hashRecord);
   use outIO;
   type hashTable is array(Integer range <>) of hashRecord;
   type probe is (linear, random);
   type hash is (mine, yours);
   type implementation is (memory, file);
   function str2Uns is new Ada.Unchecked_Conversion(slice, Unsigned_64);
   function mystr2Uns is new Ada.Unchecked_Conversion(mySlice, Unsigned_64);
   function char2Uns is new Ada.Unchecked_Conversion(character, Unsigned_64);
   function uns2Int is new Ada.Unchecked_Conversion(Unsigned_64, Integer);
   function Int2Uns is new Ada.Unchecked_Conversion(Integer, Unsigned_64);
   procedure slingHash(inFile : String; outFile : String; size : Integer; 
                       percentFull : Float; probeType : probe; hashType : hash; 
                       loc : implementation);
   procedure mainMem (inFile : String; size : Integer; percentFull : Float; 
                      probeType : probe; hashType : hash);
   procedure file (inFile : String; outFile : String; size : Integer; 
                   percentFull : Float; probeType : probe; hashType : hash);
   procedure getAvg(input : hashIO.File_Type; storage : outIO.File_Type; 
                    myTable : hashTable; lower : Integer; upper : Integer; 
                    size : Integer; probeType : probe; hashType : hash;
                    location : implementation);
   procedure getTheor (size : Integer; keys : Integer; probeType : probe);
   function getKey (Item : hElement) return Integer;
   function myKey (Item : hElement; TS : Integer) return Integer;
   --for average
   eTable : hashTable(1..2);
   eFile : outIO.File_Type;
end hash;