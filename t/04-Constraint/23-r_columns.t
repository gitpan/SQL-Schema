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
          )->r_columns,
  0
);



{
  my @rcolumns = SQL::Schema::Constraint->new(
                   'constraint_name' => 'foo',
                   'constraint_type' => 'R',
                   'columns' => [ \'faked column object' ],
                   'r_schema' => 'rfoo',
                   'r_table_name' => 'rtable',
                   'r_columns' => [ \'faked column object' ],
                 )->r_columns;
  ok(scalar @rcolumns,1);
  ok(${$rcolumns[0]},'faked column object');
}



{
  my @rcolumns = SQL::Schema::Constraint->new(
                   'constraint_name' => 'foo',
                   'constraint_type' => 'R',
                   'columns' => [ \'C', \'B', \'A' ],
                   'r_schema' => 'rfoo',
                   'r_table_name' => 'rtable',
                   'r_columns' => [ \'rC', \'rB', \'rA' ],
                 )->r_columns;
  ok(scalar @rcolumns,3);
  ok(${$rcolumns[0]},'rC');
  ok(${$rcolumns[1]},'rB');
  ok(${$rcolumns[2]},'rA');
}



exit(0);
