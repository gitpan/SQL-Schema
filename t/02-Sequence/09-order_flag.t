#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Sequence;

BEGIN {
  plan tests => 6;
}



{
  my $order_flag = SQL::Schema::Sequence->new(qw(
                     sequence_name  foo
                     increment_by   1
                     cache_size     0
                     start_with     1
                   ))
                   ->order_flag;
  ok(defined($order_flag)?'defined':'undefined','defined');
  ok($order_flag,'N');
}



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    order_flag     Y
  ))
  ->order_flag,
  'Y'
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    order_flag     N
  ))
  ->order_flag,
  'N'
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    order_flag     y
  ))
  ->order_flag,
  'Y'
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    order_flag     n
  ))
  ->order_flag,
  'N'
);



exit(0);
