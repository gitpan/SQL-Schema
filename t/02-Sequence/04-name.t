#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Sequence;

BEGIN {
  plan tests => 1;
}



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foobar
    increment_by   1
    cache_size     0
    start_with     1
  ))
  ->name,
  'foobar'
);



exit(0);
