#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::View;

BEGIN {
  plan tests => 1;
}



ok(
  SQL::Schema::View->new(
    'view_name' => 'foo',
    'subquery' => 'select * from bar',
  )->subquery,
  'select * from bar'
);



exit(0);
