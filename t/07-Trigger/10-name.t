#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Trigger;

BEGIN {
  plan tests => 1;
}



ok(
  SQL::Schema::Trigger->new(
    'trigger_name' => 'foo',
    'description'  => <<'EOD',
Foo
  before insert
  on bar
  for each row
EOD
    'trigger_body' => <<'EOB',
begin
  :new.x := 13;
end;
EOB
  )->name,
  'foo'
);



exit(0);
