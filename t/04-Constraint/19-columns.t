#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Constraint;

BEGIN {
  plan tests => 7;
}



ok(
  scalar  SQL::Schema::Constraint->new(
            'constraint_name' => 'foo',
            'constraint_type' => 'C',
            'search_condition' => 'x > 7',
          )->columns,
  0
);



{
  my @columns = SQL::Schema::Constraint->new(
                  'constraint_name' => 'foo',
                  'constraint_type' => 'U',
                  'columns' => [ \'faked column object' ],
                )->columns;
  ok(scalar @columns,1);
  ok(${$columns[0]},'faked column object');
}



{
  my @columns = SQL::Schema::Constraint->new(
                  'constraint_name' => 'foo',
                  'constraint_type' => 'U',
                  'columns' => [ \'C', \'B', \'A' ],
                )->columns;
  ok(scalar @columns,3);
  ok(${$columns[0]},'C');
  ok(${$columns[1]},'B');
  ok(${$columns[2]},'A');
}



exit(0);
