#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Table;
use SQL::Schema::Table::Column;

BEGIN {
  plan tests => 1;
}



ok(
  SQL::Schema::Table->new(
    'table_name' => 'foobar',
    'columns' => [ SQL::Schema::Table::Column->new(qw(
                   column_name foo
                   data_type   char
                 )) ],
  )->name,
  'foobar'
);



exit(0);
