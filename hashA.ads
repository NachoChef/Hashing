with Ada.Text_IO; use Ada.Text_IO;
with Direct_IO, Ada.Unchecked_Conversion;

generic
   type Element is private;
   with procedure myWrite(file : File_Type; Item : element; Location : Direct_IO.Count);
   with procedure myRead(file : File_Type; Item : element; Location : Direct_IO.Count);
package hashA is
   package hashIO is new Direct_IO(Element);
   use hashIO;
   procedure getKey(Item : in Element) return Integer;
   procedure writeKey(file : hashIO.File_Type; Item : Element; Location : Integer);
   function readKey(procedure writeKey(file : hashIO.File_Type; Location : Integer) return Element;
   function e2Uns is new Ada.Unchecked_Conversion(Element, Unsigned_64);