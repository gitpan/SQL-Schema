#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Sequence;

BEGIN {
  plan tests => 5;
}



{
  my $min_value = SQL::Schema::Sequence->new(qw(
                    sequence_name  foo
                    increment_by   1
                    cache_size     0
                    start_with     1
                  ))
                  ->min_value;
  ok(defined($min_value)?'defined':'undefined','undefined');
}



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    min_value      7
  ))
  ->min_value,
  7
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    min_value      -99999999999999999999999999999999999999
  ))
  ->min_value,
  '-99999999999999999999999999999999999999'
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     20000000000000000000000000000000000000
    min_value      +10000000000000000000000000000000000000
    max_value      +99999999999999999999999999999999999999
  ))
  ->min_value,
  '+10000000000000000000000000000000000000'
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     20000000000000000000000000000000000000
    min_value      10000000000000000000000000000000000000
    max_value      +99999999999999999999999999999999999999
  ))
  ->min_value,
  '10000000000000000000000000000000000000'
);



exit(0);
