#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Package;

require 't/connect.pl';

BEGIN {
  plan tests => 1;
}

my $dbh = Connect::db();



ok(
  SQL::Schema::Package->new(
    'name'  => 'decimals',
    'text'  => <<'EOS',
package decimals
is
  function date return integer;
end decimals;
EOS
  )->drop_statement,
  <<'EOS'
drop package decimals;
EOS
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
