#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Table::Column;

BEGIN {
  plan tests => 5;
}



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name foo
    data_type   char
  ))
  ->nullable_bool,
  1
);



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name foo
    data_type   char
    nullable    Y
  ))
  ->nullable_bool,
  1
);



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name foo
    data_type   char
    nullable    y
  ))
  ->nullable_bool,
  1
);



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name foo
    data_type   char
    nullable    N
  ))
  ->nullable_bool,
  0
);



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name foo
    data_type   char
    nullable    n
  ))
  ->nullable_bool,
  0
);



exit(0);
