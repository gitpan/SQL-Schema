#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Constraint;

BEGIN {
  plan tests => 2;
}



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'C',
    'search_condition' => 'x > 7',
  )->search_condition,
  'x > 7'
);



ok(
  defined SQL::Schema::Constraint->new(
            'constraint_name' => 'foo',
            'constraint_type' => 'P',
            'columns' => [ \'faked column object' ],
          )->search_condition
  ? 'defined' : 'undefined',
  'undefined'
);



exit(0);
