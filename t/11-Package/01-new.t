#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Package;

BEGIN {
  plan tests => 2;
}



eval {
  ok(
    ref SQL::Schema::Package->new(
      'name'  => 'decimals',
      'text'  => <<'EOS',
package decimals
is
  function date return integer;
end decimals;
EOS
    ),
    'SQL::Schema::Package'
  );
};
ok($@||'','');



exit(0);
