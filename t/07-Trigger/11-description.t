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
foo
  before insert
  on bar
  for each row
EOD
    'trigger_body' => <<'EOB',
begin
  :new.x := 13;
end;
EOB
  )->description,
  <<'EOD',
foo
  before insert
  on bar
  for each row
EOD
);



exit(0);
