#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Sequence;

BEGIN {
  plan tests => 6;
}



{
  my $order = SQL::Schema::Sequence->new(qw(
                sequence_name  foo
                increment_by   1
                cache_size     0
                start_with     1
              ))
              ->order;
  ok(defined($order)?'defined':'undefined','defined');
  ok($order,0);
}



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    order_flag     Y
  ))
  ->order,
  1
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    order_flag     N
  ))
  ->order,
  0
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    order_flag     y
  ))
  ->order,
  1
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
    order_flag     n
  ))
  ->order,
  0
);



exit(0);
