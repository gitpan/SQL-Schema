#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Package;

require 't/connect.pl';

BEGIN {
  plan tests => 3;
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
  )->create_statement,
  <<'EOS'
create package decimals
is
  function date return integer;
end decimals;
/
EOS
);



{
  my $package = SQL::Schema::Package->new(
                    'name'  => 'decimals',
                    'text'  => <<'EOS',
package decimals
is
  function date return integer;
end decimals;
EOS
                  );
  ok("$package",<<'EOS');
create package decimals
is
  function date return integer;
end decimals;
/
EOS
}



ok(
  SQL::Schema::Package
    ->select($dbh,'constants')
      ->create_statement,
  <<'EOS'
create package constants
is
  function e     return number;
  function ln2   return number;
  function sqrt2 return number;
end constants;
/
EOS
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
