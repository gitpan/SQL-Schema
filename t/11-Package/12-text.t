#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Package;

BEGIN {
  plan tests => 1;
}



ok(
  SQL::Schema::Package->new(
    'name'  => 'decimals',
    'text'  => <<'EOS',
package decimals
is
  function date return integer;
end decimals;
EOS
  )->text,
  <<'EOS'
package decimals
is
  function date return integer;
end decimals;
EOS
);



exit(0);
