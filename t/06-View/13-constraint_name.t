#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::View;

BEGIN {
  plan tests => 2;
}



{
  my $constraint_name = SQL::Schema::View->new(
                          'view_name' => 'foo',
                          'subquery' => 'select * from bar',
                        )->constraint_name;
  ok(defined $constraint_name ? 'defined' : 'undefined', 'undefined');
}



ok(
  SQL::Schema::View->new(
     'view_name' => 'foo',
     'subquery' => 'select * from bar with check option ',
     'constraint_name' => 'check_foo'
  )->constraint_name,
  'check_foo'
);



exit(0);
