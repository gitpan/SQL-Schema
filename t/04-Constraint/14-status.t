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
  )->status,
  'enabled'
);



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'C',
    'search_condition' => 'x > 7',
    'status' => 'enabled',
  )->status,
  'enabled'
);



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'C',
    'search_condition' => 'x > 7',
    'status' => 'ENABled',
  )->status,
  'enabled'
);



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'C',
    'search_condition' => 'x > 7',
    'status' => 'disabled',
  )->status,
  'disabled'
);



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'C',
    'search_condition' => 'x > 7',
    'status' => 'DISAbled',
  )->status,
  'disabled'
);



exit(0);
