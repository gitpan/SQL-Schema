#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Constraint;

BEGIN {
  plan tests => 5;
}



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'C',
    'search_condition' => 'x > 7',
  )->enabled,
  1
);



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'C',
    'search_condition' => 'x > 7',
    'status' => 'enabled',
  )->enabled,
  1
);



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'C',
    'search_condition' => 'x > 7',
    'status' => 'ENAbled',
  )->enabled,
  1
);



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'C',
    'search_condition' => 'x > 7',
    'status' => 'disabled',
  )->enabled,
  0
);



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'C',
    'search_condition' => 'x > 7',
    'status' => 'DISabled',
  )->enabled,
  0
);



exit(0);
