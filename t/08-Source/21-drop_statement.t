#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Source;

require 't/connect.pl';

BEGIN {
  plan tests => 1;
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
  )->drop_statement,
  <<'EOS'
drop procedure reset_bar;
EOS
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
