#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Sequence;

BEGIN {
  plan tests => 20;
}



eval { SQL::Schema::Sequence->new(); };
ok($@||'',"/Missing required attribute `sequence_name'/");



eval { SQL::Schema::Sequence->new('swquende_name' => 'foo'); };
ok($@||'',"/Unknown attribute `swquende_name'/");



eval {
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    cycle_flag     U
  ));
};
ok($@||'',"/Unsupported value for `cycle_flag'/");



eval {
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     x
  ));
};
ok($@||'',"/Value for `start_with' needs to be an integer/");



eval {
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     9.9
  ));
};
ok($@||'',"/Value for `start_with' needs to be an integer/");



eval {
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     999999999999999999999999999999999999999
  ));
};
ok($@||'',"/Value for `start_with' needs to be an integer/");



eval {
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     9+e09
  ));
};
ok($@||'',"/Value for `start_with' needs to be an integer/");



eval {
  ok(
    ref SQL::Schema::Sequence->new(qw(
          sequence_name  foo
          increment_by   1
          cache_size     0
          start_with     1
        )),
    'SQL::Schema::Sequence'
  );
};
ok($@||'','');



eval {
  ok(
    ref SQL::Schema::Sequence->new(qw(
          sequence_name  foo
          increment_by   +1
          cache_size     0
          start_with     1
        )),
    'SQL::Schema::Sequence'
  );
};
ok($@||'','');



eval {
  ok(
    ref SQL::Schema::Sequence->new(qw(
          sequence_name  foo
          increment_by   -1
          cache_size     0
          start_with     1
        )),
    'SQL::Schema::Sequence'
  );
};
ok($@||'','');



eval {
  ok(
    ref SQL::Schema::Sequence->new(qw(
          sequence_name  foo
          increment_by   1
          cache_size     0
          start_with     1
          max_value      99999999999999999999999999999999999999
        )),
    'SQL::Schema::Sequence'
  );
};
ok($@||'','');



eval {
  ok(
    ref SQL::Schema::Sequence->new(qw(
          sequence_name  foo
          increment_by   1
          cache_size     0
          start_with     1
          max_value      +99999999999999999999999999999999999999
        )),
    'SQL::Schema::Sequence'
  );
};
ok($@||'','');



eval {
  ok(
    ref SQL::Schema::Sequence->new(qw(
          sequence_name  foo
          increment_by   1
          cache_size     0
          start_with     1
          min_value      -99999999999999999999999999999999999999
        )),
    'SQL::Schema::Sequence'
  );
};
ok($@||'','');



ok(
  ref SQL::Schema::Sequence->new(qw(
        schema_name    BAR
        sequence_name  foo
        min_value      -7
        max_value      +11
        increment_by   2
        cycle_flag     Y
        order_flag     Y
        cache_size     3
        start_with     5
      )),
  'SQL::Schema::Sequence'
);



exit(0);
