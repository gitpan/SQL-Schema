#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::View;

require 't/connect.pl';

BEGIN {
  plan tests => 6;
}

my $dbh = Connect::db();



ok(
  SQL::Schema::View->new(
    'view_name' => 'foo',
    'subquery' => 'select * from bar',
  )->create_statement,
  <<'EOS'
create view foo
  as select * from bar;
EOS
);



{
  my $view = SQL::Schema::View->new(
               'view_name' => 'foo',
               'subquery' => 'select * from bar',
             );
  ok("$view",<<'EOS');
create view foo
  as select * from bar;
EOS
}



ok(
  SQL::Schema::View->new(
    'view_name' => 'foo',
    'subquery' => 'select * from bar',
    'aliases' => [ 'x', 'y', 'z' ],
  )->create_statement,
  <<'EOS'
create view foo ( x, y, z )
  as select * from bar;
EOS
);



ok(
  SQL::Schema::View->new(
    'view_name' => 'foo',
    'subquery' => 'select * from bar with check option ',
    'aliases' => [ 'x', 'y', 'z' ],
    'constraint_name' => 'check_foo',
  )->create_statement,
  <<'EOS'
create view foo ( x, y, z )
  as select * from bar with check option   constraint check_foo;
EOS
);



ok(
  SQL::Schema::View->select($dbh,'v_pixelcolors')->create_statement,
  <<'EOS',
create view v_pixelcolors ( pix_x, pix_y, col_cyan, col_magenta, col_yellow, col_black )
  as select p.x, p.y, c.cyan, c.magenta, c.yellow, c.black
       from pixels p, colors c
       where p.color_id = c.id
  with read only;
EOS
);



ok(
  SQL::Schema::View->select($dbh,'colours')->create_statement,
  <<'EOS',
create view colours ( id, cyan, magenta, yellow, black )
  as select id, cyan, magenta, yellow, black from colors
  with check option   constraint colours_check;
EOS
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
