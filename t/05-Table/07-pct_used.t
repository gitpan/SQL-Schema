#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Table;
use SQL::Schema::Table::Column;

BEGIN {
  plan tests => 2;
}



{
  my $pct_used =
    SQL::Schema::Table->new(
      'table_name' => 'FooBar',
      'columns' => [ SQL::Schema::Table::Column->new(qw(
                     column_name foo
                     data_type   char
                   )) ],
    )->pct_used;
  ok(defined $pct_used?'defined':'undefined','undefined');
}



ok(
  SQL::Schema::Table->new(
    'table_name' => 'FooBar',
    'columns' => [ SQL::Schema::Table::Column->new(qw(
                   column_name foo
                   data_type   char
                 )) ],
    'pct_used' => 81,
  )->pct_used,
  81
);



exit(0);
