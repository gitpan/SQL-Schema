#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Procedure;

require 't/connect.pl';

BEGIN {
  plan tests => 3;
}

my $dbh = Connect::db();



ok(
  SQL::Schema::Procedure->new(
    'name'  => 'reset_bar',
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
  my $procedure = SQL::Schema::Procedure->new(
                    'name'  => 'reset_bar',
                    'text'  => <<'EOS',
procedure reset_bar
as
begin
  update bar set x = 0;
end;
EOS
                  );
  ok("$procedure",<<'EOS');
create procedure reset_bar
as
begin
  update bar set x = 0;
end;
/
EOS
}



ok(
  SQL::Schema::Procedure
    ->select($dbh,'mirror_picture_horizontally')
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
