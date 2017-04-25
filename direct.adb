with direct_io;  --in file mkdirect.ada & directio.doc
with text_io;
procedure mkdirect is
type rec is record
      i:integer;
      a:string(1..5);
end record;

package iio is new text_io.integer_io(integer);
use iio;

package io_direct is new direct_io(rec);
use io_direct;

pt: positive_count;       -- 1, 2, 3, …
f1:file_type;

rec1: rec;
j: integer := 0;

begin
create(f1, inout_file, "joedir");
rec1.a := "abcde";
reset(f1);
-- COUNT and POSITIVE_COUNT are defined in package direct_io;
for pt in positive_count range 1..10 loop
  j := j + 1;
  rec1.i := j;
  write(f1, rec1, pt);
end loop;
close(f1);

open(f1,inout_file,"joedir");
reset(f1);
for pt in positive_count range 1..10 loop
read(f1, rec1, pt);
	text_io.put(rec1.a);  iio.put(rec1.i);  text_io.new_line;
end loop;
close(f1);
end mkdirect;
