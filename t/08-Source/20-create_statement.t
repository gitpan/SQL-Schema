#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Source;

require 't/connect.pl';

BEGIN {
  plan tests => 3;
}

my $dbh = Connect::db();



ok(
  SQL::Schema::Source->new(
    'name'  => 'reset_bar',
    'type'  => 'procedure',
    'text'  => <<'EOS',
procedure reset_bar
as
begin
  update bar set x = 0;
end;
EOS
  )->create_statement,
  <<'EOS'
create procedure reset_bar
as
begin
  update bar set x = 0;
end;
/
EOS
);



{
  my $source = SQL::Schema::Source->new(
                 'name'  => 'reset_bar',
                 'type'  => 'procedure',
                 'text'  => <<'EOS',
procedure reset_bar
as
begin
  update bar set x = 0;
end;
EOS
               );
  ok("$source",<<'EOS');
create procedure reset_bar
as
begin
  update bar set x = 0;
end;
/
EOS
}



ok(
  SQL::Schema::Source
    ->select($dbh,'mirror_picture_horizontally','procedure')
      ->create_statement,
  <<'EOS'
create procedure mirror_picture_horizontally
as
begin
  update pixels set x = 1023 - x;
end;
/
EOS
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
