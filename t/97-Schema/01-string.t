#  -*- perl -*-

use strict;
use Test;
use SQL::Schema;

require 't/connect.pl';

BEGIN {
  plan tests => 1;
}

my $dbh = Connect::db();



ok(SQL::Schema->new($dbh)->string,<<'EOS');
create sequence nadja
  minvalue 3
  maxvalue 11
  increment by 2
  cycle
  order
  nocache
  start with 7;

create sequence ramona
  minvalue 1
  maxvalue 999999999999999999999999999
  increment by 1
  nocycle
  noorder
  cache 20
  start with 2;

create table colors (
  id number(22,0) not null,
  cyan number(22,0) default 7,
  magenta char(7) not null,
  yellow number(11,3),
  black number(22,0),
constraint colors_pkey primary key (
  id
)
not deferrable initially immediate
enable validate,
constraint colors_skey unique (
  cyan,
  magenta,
  yellow,
  black
)
not deferrable initially immediate
enable validate
)
  pctfree 10
  pctused 40
  initrans 1;

create table pixels (
  x number(22,0) not null,
  y number(22,0) not null,
  color_id number(22,0),
constraint pixels_pkey primary key (
  x,
  y
)
not deferrable initially immediate
enable validate,
constraint pixels_ref_colors foreign key (
  color_id
)
references sql_test.colors (
  id
)
on delete cascade
not deferrable initially immediate
enable validate,
constraint pixels_x_range check ( 0 <= x and x < 1024 )
not deferrable initially immediate
enable validate,
constraint pixels_y_range check ( 0 <= y and y < 768 )
not deferrable initially immediate
enable validate
)
  pctfree 11
  pctused 41
  initrans 2;

create table text_files (
  id number(22,0) not null,
  text long default 'empty',
primary key (
  id
)
not deferrable initially immediate
enable validate
)
  pctfree 10
  pctused 40
  initrans 1;

create view colours ( id, cyan, magenta, yellow, black )
  as select id, cyan, magenta, yellow, black from colors
  with check option   constraint colours_check;

create view insertable_pixelcolors ( pix_x, pix_y, col_id, col_cyan, col_magenta, col_yellow, col_black )
  as select p.x, p.y, c.id, c.cyan, c.magenta, c.yellow, c.black
       from pixels p, colors c
       where p.color_id = c.id;

create view v_pixelcolors ( pix_x, pix_y, col_cyan, col_magenta, col_yellow, col_black )
  as select p.x, p.y, c.cyan, c.magenta, c.yellow, c.black
       from pixels p, colors c
       where p.color_id = c.id
  with read only;

create procedure mirror_picture_horizontally
as
begin
  update pixels set x = 1023 - x;
end;
/

create function const_pi
  return number
as
begin
  return(3.14159265358979323846);
end;
/

create package constants
is
  function e     return number;
  function ln2   return number;
  function sqrt2 return number;
end constants;
/

create package body constants
is
  function e
    return number
  is
  begin
    return(2.7182818284590452354);
  end e;
  function ln2
    return number
  is
  begin
    return(0.69314718055994530942);
  end ln2;
  function sqrt2
    return number
  is
  begin
    return(1.41421356237309504880);
  end sqrt2;
end constants;
/

create trigger clip_pixels
  before insert or update of x,y
  on pixels
  referencing old as o new as n
  for each row
  when ( n.x > 1023 or n.y > 767 or n.x < 0 or n.y < 0 )
declare
  min_x integer := 0;
  min_y integer := 0;
begin
  :n.x := min_x;
  :n.y := min_y;
end;
/

create trigger i_pixelcolors
  instead of insert
  on insertable_pixelcolors
begin
  insert into colors ( id, cyan, magenta, yellow, black )
  values ( :new.col_id, :new.col_cyan, :new.col_magenta, :new.col_yellow,
           :new.col_black );
  insert into pixels ( x, y, color_id )
  values ( :new.pix_y, :new.pix_y, :new.col_id );
end;
/
EOS



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
