#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::View;

BEGIN {
  plan tests => 7;
}



{
  my @aliases = SQL::Schema::View->new(
                  'view_name' => 'foo',
                  'subquery' => 'select * from bar',
                )->aliases;
  ok(scalar @aliases,0);
}



{
  my @aliases = SQL::Schema::View->new(
                  'view_name' => 'foo',
                  'subquery' => 'select * from bar',
                  'aliases' => [ 'x' ],
                )->aliases;
  ok(scalar @aliases,1);
  ok($aliases[0],'x');
}



{
  my @aliases = SQL::Schema::View->new(
                  'view_name' => 'foo',
                  'subquery' => 'select * from bar',
                  'aliases' => [ 'x', 'y', 'z' ],
                )->aliases;
  ok(scalar @aliases,3);
  ok($aliases[0],'x');
  ok($aliases[1],'y');
  ok($aliases[2],'z');
}



exit(0);
