#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Package::Body;

require 't/connect.pl';

BEGIN {
  plan tests => 1;
}

my $dbh = Connect::db();



ok(
  SQL::Schema::Package::Body->new(
    'name'  => 'decimals',
    'text'  => <<'EOS',
create package body decimals
is
  function date return integer is
  begin
    return(-1);
  end date;
end decimals;
EOS
  )->drop_statement,
  <<'EOS'
drop package body decimals;
EOS
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
