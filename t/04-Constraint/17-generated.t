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
  )->generated,
  'user name'
);



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'C',
    'search_condition' => 'x > 7',
    'generated' => 'generated name',
  )->generated,
  'generated name'
);



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'C',
    'search_condition' => 'x > 7',
    'generated' => 'generated NAME',
  )->generated,
  'generated name'
);



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'C',
    'search_condition' => 'x > 7',
    'generated' => 'user name',
  )->generated,
  'user name'
);



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'C',
    'search_condition' => 'x > 7',
    'generated' => 'user NAME',
  )->generated,
  'user name'
);



exit(0);
