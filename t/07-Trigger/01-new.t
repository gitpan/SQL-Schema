#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Trigger;

BEGIN {
  plan tests => 6;
}



####################
#
# negative tests
#
####################


# Required attribute missing
eval { SQL::Schema::Trigger->new(); };
ok($@||'',"/Missing required attribute `trigger_name'/");



# Misspelled attribute
eval { SQL::Schema::Trigger->new('tigger_name' => 'foo'); };
ok($@||'',"/Unknown attribute `tigger_name'/");



####################
#
# positive tests
#
####################


# Minimal set of valid attributes
eval {
  ok(
    ref SQL::Schema::Trigger->new(
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
    ),
    'SQL::Schema::Trigger'
  );
};
ok($@||'','');



# Largest set of valid attributes
eval {
  ok(
    ref SQL::Schema::Trigger->new(
      'trigger_name'    => 'foo',
      'description'  => <<'EOD',
foo
  before insert
  on bar
  for each row
EOD
      'when_clause' => ' new.x > 13 ',
      'trigger_body' => <<'EOB',
begin
  :new.x := 13;
end;
EOB
    ),
    'SQL::Schema::Trigger'
  );
};
ok($@||'','');



exit(0);
