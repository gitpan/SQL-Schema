#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Sequence;

BEGIN {
  plan tests => 6;
}



{
  my $cycle_flag = SQL::Schema::Sequence->new(qw(
                     sequence_name  foo
                     increment_by   1
                     cache_size     0
                     start_with     1
                   ))
                   ->cycle_flag;
  ok(defined($cycle_flag)?'defined':'undefined','defined');
  ok($cycle_flag,'N');
}



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    cycle_flag     Y
  ))
  ->cycle_flag,
  'Y'
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    cycle_flag     N
  ))
  ->cycle_flag,
  'N'
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    cycle_flag     y
  ))
  ->cycle_flag,
  'Y'
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    cycle_flag     n
  ))
  ->cycle_flag,
  'N'
);



exit(0);
