#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Table;
use SQL::Schema::Table::Column;

BEGIN {
  plan tests => 2;
}



ok(
  SQL::Schema::Table->new(
    'table_name' => 'foo',
    'columns' => [ SQL::Schema::Table::Column->new(qw(
                   column_name foo
                   data_type   char
                 )) ],
  )->qualified_name,
  'foo'
);



ok(
  SQL::Schema::Table->new(
    'schema_name' => 'bar',
    'table_name' => 'foo',
    'columns' => [ SQL::Schema::Table::Column->new(qw(
                   column_name foo
                   data_type   char
                 )) ],
  )->qualified_name,
  'bar.foo'
);



exit(0);
