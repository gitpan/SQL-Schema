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
    increment_by   7
    cache_size     0
    start_with     1
  ))
  ->increment_by,
  7
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   +10000000000000000000000000000000000000
    cache_size     0
    start_with     1
  ))
  ->increment_by,
  '+10000000000000000000000000000000000000'
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   -20000000000000000000000000000000000000
    cache_size     0
    start_with     1
  ))
  ->increment_by,
  '-20000000000000000000000000000000000000'
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   39999999999999999999999999999999999999
    cache_size     0
    start_with     1
  ))
  ->increment_by,
  '39999999999999999999999999999999999999'
);



exit(0);
