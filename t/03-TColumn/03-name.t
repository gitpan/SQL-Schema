#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Table::Column;

BEGIN {
  plan tests => 1;
}



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name foo
    data_type   integer
  ))
  ->name,
  'foo'
);



exit(0);
