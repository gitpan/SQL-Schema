#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Constraint;

BEGIN {
  plan tests => 2;
}



ok(
  defined SQL::Schema::Constraint->new(
            'constraint_name' => 'foo',
            'constraint_type' => 'C',
            'search_condition' => 'x > 7',
          )->r_schema
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
  )->r_schema,
  'rfoo'
);



exit(0);
