#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Source;

BEGIN {
  plan tests => 1;
}



ok(
  SQL::Schema::Source->new(
    'name'  => 'reset_bar',
    'type'  => 'procedure',
    'text'  => <<'EOS',
procedure reset_bar
as
begin
  update bar set x = 0;
end;
EOS
  )->name,
  'reset_bar'
);



exit(0);
