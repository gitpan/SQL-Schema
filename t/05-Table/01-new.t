#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Constraint;
use SQL::Schema::Table;
use SQL::Schema::Table::Column;

BEGIN {
  plan tests => 11;
}



eval { SQL::Schema::Table->new(); };
ok($@||'',"/Missing required attribute `table_name'/");



eval { SQL::Schema::Table->new('tsble_name' => 'foo'); };
ok($@||'',"/Unknown attribute `tsble_name'/");



eval { SQL::Schema::Table->new('table_name' => 'foo', 'columns' => 'bar'); };
ok($@||'',"/Attribute `columns' needs to be an array reference/");



eval { SQL::Schema::Table->new('table_name' => 'foo', 'columns' => []); };
ok($@||'',"/At least one column is required/");



eval {
  SQL::Schema::Table->new(
    'table_name' => 'foo',
    'columns' => [ SQL::Schema::Table::Column->new(qw(
                   column_name foo
                   data_type   char
                 )) ],
    'pct_free' => 'x',
  );
};
ok($@||'',"/Value for `pct_free' needs to be a positive integer or zero/");



eval {
  ok(
    ref SQL::Schema::Table->new(
          'table_name' => 'foo',
          'columns' => [ SQL::Schema::Table::Column->new(qw(
                         column_name foo
                         data_type   char
                       )) ],
    ),
    'SQL::Schema::Table'
  );
};
ok($@||'','');



eval {
  ok(
    ref SQL::Schema::Table->new(
          'schema_name' => 'bar',
          'table_name' => 'foo',
          'columns' => [ SQL::Schema::Table::Column->new(qw(
                         column_name foo
                         data_type   char
                       )) ],
          'pct_free' => 17,
          'pct_used' => 80,
          'ini_trans' => 5,
    ),
    'SQL::Schema::Table'
  );
};
ok($@||'','');



eval {
  ok(
    ref SQL::Schema::Table->new(
          'schema_name' => 'bar',
          'table_name' => 'foo',
          'columns' => [ SQL::Schema::Table::Column->new(qw(
                         column_name foo
                         data_type   char
                       )) ],
          'constraints' => [ SQL::Schema::Constraint->new(
                             'constraint_name' => 'check_foo',
                             'constraint_type' => 'C',
                             'search_condition' => "foo in ( 'T', 'F' )",
                           ) ],
          'pct_free' => 17,
          'pct_used' => 80,
          'ini_trans' => 5,
    ),
    'SQL::Schema::Table'
  );
};
ok($@||'','');



exit(0);
