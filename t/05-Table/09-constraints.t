#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Constraint;
use SQL::Schema::Table;
use SQL::Schema::Table::Column;

BEGIN {
  plan tests => 4;
}


ok(
  scalar SQL::Schema::Table->new(
    'table_name' => 'FooBar',
    'columns' =>   [ SQL::Schema::Table::Column->new(qw(
                     column_name foo
                     data_type   char
                   )) ],
  )->constraints,
  0
);


{
  my @constraints =
    SQL::Schema::Table->new(
      'table_name' => 'FooBar',
      'columns' => [ SQL::Schema::Table::Column->new(qw(
                     column_name foo
                     data_type   char
                   )) ],
      'constraints' => [ SQL::Schema::Constraint->new(
                         'constraint_name' => 'check_foo',
                         'constraint_type' => 'C',
                         'search_condition' => "foo in ( 'T', 'F' )",
                         ),
                         SQL::Schema::Constraint->new(
                         'constraint_name' => 'unique_foo',
                         'constraint_type' => 'U',
                         'columns' => [ SQL::Schema::Table::Column->new(qw(
                                        column_name foo
                                        data_type   char
                                      )) ],
                       ) ],
    )->constraints;
  ok(scalar @constraints,2);
  ok($constraints[0]->name, 'check_foo');
  ok($constraints[1]->name, 'unique_foo');
}



exit(0);
