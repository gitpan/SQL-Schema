#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Procedure;

BEGIN {
  plan tests => 2;
}



eval {
  ok(
    ref SQL::Schema::Procedure->new(
      'name'  => 'reset_bar',
      'text'  => <<'EOS',
procedure reset_bar
as
begin
  update bar set x = 0;
end;
EOS
    ),
    'SQL::Schema::Procedure'
  );
};
ok($@||'','');



exit(0);
