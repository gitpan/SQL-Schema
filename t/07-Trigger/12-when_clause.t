#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Trigger;

BEGIN {
  plan tests => 2;
}



{
  my $when_clause = SQL::Schema::Trigger->new(
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
                    )->when_clause;
  ok(defined $when_clause?'defined':'undefined','undefined');
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
    'when_clause' => ' new.x > 13 ',
    'trigger_body' => <<'EOB',
begin
  :new.x := 13;
end;
EOB
  )->when_clause,
  ' new.x > 13 '
);



exit(0);
