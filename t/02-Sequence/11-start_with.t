#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Sequence;

BEGIN {
  plan tests => 4;
}



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     17
  ))
  ->start_with,
  17
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     -22222222222222222222222222222222222222
    min_value      -99999999999999999999999999999999999999
  ))
  ->start_with,
  '-22222222222222222222222222222222222222'
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     +20000000000000000000000000000000000000
  ))
  ->start_with,
  '+20000000000000000000000000000000000000'
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     20000000000000000000000000000000000000
  ))
  ->start_with,
  '20000000000000000000000000000000000000'
);



exit(0);
