#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Package::Body;

require 't/connect.pl';

BEGIN {
  plan tests => 3;
}

my $dbh = Connect::db();



ok(
  SQL::Schema::Package::Body->new(
    'name'  => 'decimals',
    'text'  => <<'EOS',
package body decimals
is
  function date return integer is
  begin
    return(-1);
  end date;
end decimals;
EOS
  )->create_statement,
  <<'EOS'
create package body decimals
is
  function date return integer is
  begin
    return(-1);
  end date;
end decimals;
/
EOS
);



{
  my $body = SQL::Schema::Package::Body->new(
               'name'  => 'decimals',
               'text'  => <<'EOS',
package body decimals
is
  function date return integer is
  begin
    return(-1);
  end date;
end decimals;
EOS
             );
  ok("$body",<<'EOS');
create package body decimals
is
  function date return integer is
  begin
    return(-1);
  end date;
end decimals;
/
EOS
}



ok(
  SQL::Schema::Package::Body
    ->select($dbh,'constants')
      ->create_statement,
  <<'EOS'
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
EOS
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
