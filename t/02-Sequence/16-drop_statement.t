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
  ->drop_statement,
  <<'EOS',
drop sequence foo;
EOS
);



ok(
  SQL::Schema::Sequence->new(qw(
    schema_name    bar
    sequence_name  foo
    increment_by   1
    cache_size     0
    start_with     1
  ))
  ->drop_statement,
  <<'EOS',
drop sequence bar.foo;
EOS
);



exit(0);
