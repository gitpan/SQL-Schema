#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Package::Body;

BEGIN {
  plan tests => 2;
}



eval {
  ok(
    ref SQL::Schema::Package::Body->new(
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
    ),
    'SQL::Schema::Package::Body'
  );
};
ok($@||'','');



exit(0);
