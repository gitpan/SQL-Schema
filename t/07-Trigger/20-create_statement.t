#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Trigger;

require 't/connect.pl';

BEGIN {
  plan tests => 4;
}

my $dbh = Connect::db();



ok(
  SQL::Schema::Trigger->new(
    'trigger_name' => 'foo',
    'description'  => <<'EOD',
foo
  before insert
  on bar
  for each row
EOD
    'trigger_body' => <<'EOB',
begin
  :new.x := 13;
end;
EOB
  )->create_statement,
  <<'EOS'
create trigger foo
  before insert
  on bar
  for each row
begin
  :new.x := 13;
end;
/
EOS
);



{
  my $trigger = SQL::Schema::Trigger->new(
                  'trigger_name' => 'foo',
                  'description'  => <<'EOD',
foo
  before insert
  on bar
  for each row
EOD
                  'trigger_body' => <<'EOB',
begin
  :new.x := 13;
end;
EOB
                );
  ok("$trigger",<<'EOS');
create trigger foo
  before insert
  on bar
  for each row
begin
  :new.x := 13;
end;
/
EOS
}



ok(
  SQL::Schema::Trigger->select($dbh,'clip_pixels')->create_statement,
  <<'EOS',
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
EOS
);



ok(
  SQL::Schema::Trigger->select($dbh,'i_pixelcolors')->create_statement,
  <<'EOS',
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
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
