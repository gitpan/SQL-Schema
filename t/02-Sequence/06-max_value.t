#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Sequence;

BEGIN {
  plan tests => 5;
}


{
  my $max_value = SQL::Schema::Sequence->new(qw(
                    sequence_name  foo
                    increment_by   1
                    cache_size     0
                    start_with     1
                  ))
                  ->max_value;
  ok(defined($max_value)?'defined':'undefined','undefined');
}



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    max_value      7
  ))
  ->max_value,
  7
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    max_value      +99999999999999999999999999999999999999
  ))
  ->max_value,
  '+99999999999999999999999999999999999999'
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     -30000000000000000000000000000000000000
    min_value      -99999999999999999999999999999999999999
    max_value      -20000000000000000000000000000000000000
  ))
  ->max_value,
  '-20000000000000000000000000000000000000'
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    max_value      99999999999999999999999999999999999999
  ))
  ->max_value,
  '99999999999999999999999999999999999999'
);



exit(0);
