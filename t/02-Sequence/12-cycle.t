#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Sequence;

BEGIN {
  plan tests => 6;
}



{
  my $cycle = SQL::Schema::Sequence->new(qw(
                sequence_name  foo
                increment_by   1
                cache_size     0
                start_with     1
              ))
              ->cycle;
  ok(defined($cycle)?'defined':'undefined','defined');
  ok($cycle,0);
}



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    cycle_flag     Y
  ))
  ->cycle,
  1
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    cycle_flag     N
  ))
  ->cycle,
  0
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    cycle_flag     y
  ))
  ->cycle,
  1
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    cycle_flag     n
  ))
  ->cycle,
  0
);



exit(0);
