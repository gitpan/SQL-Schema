#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Table;
use SQL::Schema::Table::Column;

BEGIN {
  plan tests => 2;
}



{
  my $pct_free =
    SQL::Schema::Table->new(
      'table_name' => 'FooBar',
      'columns' => [ SQL::Schema::Table::Column->new(qw(
                     column_name foo
                     data_type   char
                   )) ],
    )->pct_free;
  ok(defined $pct_free?'defined':'undefined','undefined');
}



ok(
  SQL::Schema::Table->new(
    'table_name' => 'FooBar',
    'columns' => [ SQL::Schema::Table::Column->new(qw(
                   column_name foo
                   data_type   char
                 )) ],
    'pct_free' => 17,
  )->pct_free,
  17
);



exit(0);
