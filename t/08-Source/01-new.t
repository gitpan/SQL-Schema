#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Source;

BEGIN {
  plan tests => 4;
}



####################
#
# negative tests
#
####################


# Required attribute missing
eval { SQL::Schema::Source->new(); };
ok($@||'',"/Missing required attribute `name'/");



# Misspelled attribute
eval { SQL::Schema::Source->new('nme' => 'foo'); };
ok($@||'',"/Unknown attribute `nme'/");



####################
#
# positive tests
#
####################


eval {
  ok(
    ref SQL::Schema::Source->new(
      'name'  => 'reset_bar',
      'type'  => 'procedure',
      'text'  => <<'EOS',
procedure reset_bar
as
begin
  update bar set x = 0;
end;
EOS
    ),
    'SQL::Schema::Source'
  );
};
ok($@||'','');



exit(0);
