#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Table;
use SQL::Schema::Table::Column;

BEGIN {
  plan tests => 2;
}



{
  my @columns =
    SQL::Schema::Table->new(
      'table_name' => 'FooBar',
      'columns' => [ SQL::Schema::Table::Column->new(qw(
                     column_name foo
                     data_type   char
                   )) ],
    )->columns;
  ok(scalar @columns,1);
  ok(ref $columns[0], 'SQL::Schema::Table::Column');
}



exit(0);
