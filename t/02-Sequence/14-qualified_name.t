#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Sequence;

BEGIN {
  plan tests => 2;
}



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
  ))
  ->qualified_name,
  'foo'
);



ok(
  SQL::Schema::Sequence->new(qw(
    schema_name    bar
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
  ))
  ->qualified_name,
  'bar.foo'
);



exit(0);
