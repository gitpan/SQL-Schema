#  -*- perl -*-

use strict;
use Test;

require 't/connect.pl';

BEGIN {
  plan tests => 14;
}

my $dbh = Connect::db();

ok($dbh->do(<<';'),'0E0');
create sequence ramona
  minvalue 1
  maxvalue 999999999999999999999999999
  increment by 1
  nocycle
  noorder
  cache 20
  start with 1
;

ok($dbh->do(<<';'),'0E0');
create sequence nadja
  minvalue 3
  maxvalue 11
  increment by 2
  cycle
  order
  nocache
  start with 5
;

ok($dbh->do(<<';'),'0E0');
create table colors (
  id       integer constraint colors_pkey primary key,
  cyan     integer default 7,
  magenta  char(7) not null,
  yellow   dec(11,3),
  black    number(22,0),
  constraint colors_skey unique(cyan, magenta, yellow, black)
)
pctfree 10 pctused 40 initrans 1
;

ok($dbh->do(<<';'),'0E0');
create table pixels (
  x          integer,
  y          integer constraint pixels_y_range check ( 0 <= y and y < 768 ),
  color_id   integer constraint pixels_ref_colors references colors(id)
                     on delete cascade,
  constraint pixels_pkey primary key (x,y),
  constraint pixels_x_range check ( 0 <= x and x < 1024 )
)
pctfree 11 pctused 41 initrans 2
;

ok($dbh->do(<<';'),'0E0');
create table text_files (
  id integer primary key,
  text long default 'empty'
)
;

ok($dbh->do(<<';'),'0E0');
create view v_pixelcolors
  ( pix_x, pix_y, col_cyan, col_magenta, col_yellow, col_black )
  as select p.x, p.y, c.cyan, c.magenta, c.yellow, c.black
       from pixels p, colors c
       where p.color_id = c.id
  with read only
;

ok($dbh->do(<<';'),'0E0');
create view insertable_pixelcolors
  ( pix_x, pix_y, col_id, col_cyan, col_magenta, col_yellow, col_black )
  as select p.x, p.y, c.id, c.cyan, c.magenta, c.yellow, c.black
       from pixels p, colors c
       where p.color_id = c.id
;

ok($dbh->do(<<';'),'0E0');
create view colours
  as select id, cyan, magenta, yellow, black from colors
  with check option constraint colours_check
;

ok($dbh->do(<<'/'),'0E0');
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

ok($dbh->do(<<'/'),'0E0');
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

ok($dbh->do(<<'/'),'0E0');
create procedure mirror_picture_horizontally
as
begin
  update pixels set x = 1023 - x;
end;
/

ok($dbh->do(<<'/'),'0E0');
create function const_pi
  return number
as
begin
  return(3.14159265358979323846);
end;
/

ok($dbh->do(<<'/'),'0E0');
create package constants
is
  function e     return number;
  function ln2   return number;
  function sqrt2 return number;
end constants;
/

ok($dbh->do(<<'/'),'0E0');
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

$dbh->disconnect;
undef $dbh;

exit(0);
