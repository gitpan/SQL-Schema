#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Constraint;

BEGIN {
  plan tests => 1;
}



ok(
  SQL::Schema::Constraint->new(
    'constraint_name' => 'foo',
    'constraint_type' => 'C',
    'search_condition' => 'x > 7',
  )->name,
  'foo'
);



exit(0);
