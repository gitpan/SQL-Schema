#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Function;

BEGIN {
  plan tests => 2;
}



eval {
  ok(
    ref SQL::Schema::Function->new(
      'name'  => 'const_e',
      'text'  => <<'EOS',
function const_e
  return number
as
begin
  return(2.7182818284590452354);
end;
EOS
    ),
    'SQL::Schema::Function'
  );
};
ok($@||'','');



exit(0);
