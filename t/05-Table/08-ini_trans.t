#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Table;
use SQL::Schema::Table::Column;

BEGIN {
  plan tests => 2;
}



{
  my $ini_trans =
    SQL::Schema::Table->new(
      'table_name' => 'FooBar',
      'columns' => [ SQL::Schema::Table::Column->new(qw(
                     column_name foo
                     data_type   char
                   )) ],
    )->ini_trans;
  ok(defined $ini_trans?'defined':'undefined','undefined');
}



ok(
  SQL::Schema::Table->new(
    'table_name' => 'FooBar',
    'columns' => [ SQL::Schema::Table::Column->new(qw(
                   column_name foo
                   data_type   char
                 )) ],
    'ini_trans' => 5,
  )->ini_trans,
  5
);



exit(0);
