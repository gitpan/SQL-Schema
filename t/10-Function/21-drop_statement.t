#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Function;

require 't/connect.pl';

BEGIN {
  plan tests => 1;
}

my $dbh = Connect::db();



ok(
  SQL::Schema::Function->new(
    'name'  => 'const_e',
    'text'  => <<'EOS',
function const_e
  return number
as
begin
  return(2.7182818284590452354);
end;
EOS
  )->drop_statement,
  <<'EOS'
drop function const_e;
EOS
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
