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
  ->nullable,
  'Y'
);



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name foo
    data_type   char
    nullable    Y
  ))
  ->nullable,
  'Y'
);



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name foo
    data_type   char
    nullable    y
  ))
  ->nullable,
  'Y'
);



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name foo
    data_type   char
    nullable    N
  ))
  ->nullable,
  'N'
);



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name foo
    data_type   char
    nullable    n
  ))
  ->nullable,
  'N'
);



exit(0);
