#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Constraint;

BEGIN {
  plan tests => 6;
}



ok(
  defined SQL::Schema::Constraint->new(
            'constraint_name' => 'foo',
            'constraint_type' => 'C',
            'search_condition' => 'x > 7',
          )->delete_rule
  ? 'defined' : 'undefined',
  'undefined'
);



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'R',
    'columns' => [ \'faked column object' ],
    'r_schema' => 'rfoo',
    'r_table_name' => 'rtable',
    'r_columns' => [ \'faked column object' ],
  )->delete_rule,
  'no action'
);



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'R',
    'delete_rule' => 'cascade',
    'columns' => [ \'faked column object' ],
    'r_schema' => 'rfoo',
    'r_table_name' => 'rtable',
    'r_columns' => [ \'faked column object' ],
  )->delete_rule,
  'cascade'
);



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'R',
    'delete_rule' => 'CasCade',
    'columns' => [ \'faked column object' ],
    'r_schema' => 'rfoo',
    'r_table_name' => 'rtable',
    'r_columns' => [ \'faked column object' ],
  )->delete_rule,
  'cascade'
);



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'R',
    'delete_rule' => 'no action',
    'columns' => [ \'faked column object' ],
    'r_schema' => 'rfoo',
    'r_table_name' => 'rtable',
    'r_columns' => [ \'faked column object' ],
  )->delete_rule,
  'no action'
);



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'R',
    'delete_rule' => 'NO action',
    'columns' => [ \'faked column object' ],
    'r_schema' => 'rfoo',
    'r_table_name' => 'rtable',
    'r_columns' => [ \'faked column object' ],
  )->delete_rule,
  'no action'
);



exit(0);
