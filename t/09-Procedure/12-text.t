#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Procedure;

BEGIN {
  plan tests => 1;
}



ok(
  SQL::Schema::Procedure->new(
    'name'  => 'reset_bar',
    'text'  => <<'EOS',
procedure reset_bar
as
begin
  update bar set x = 0;
end;
EOS
  )->text,
  <<'EOS'
procedure reset_bar
as
begin
  update bar set x = 0;
end;
EOS
);



exit(0);
