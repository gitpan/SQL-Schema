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
    'schema_name' => 'nina',
    'table_name' => 'pinta',
    'columns' => [ SQL::Schema::Table::Column->new(qw(
                   column_name maria
                   data_type   char
                 )) ],
  )->drop_statement,
  <<'EOS',
drop table nina.pinta;
EOS
);



ok(
  SQL::Schema::Table->new(
    'table_name' => 'pinta',
    'columns' => [ SQL::Schema::Table::Column->new(qw(
                   column_name maria
                   data_type   char
                 )) ],
  )->drop_statement,
  <<'EOS',
drop table pinta;
EOS
);



exit(0);
