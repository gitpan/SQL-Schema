#  -*- perl -*

use strict;
use Test;
use SQL::Schema::View;

BEGIN {
  plan tests => 7;
}



####################
#
# negative tests
#
####################


# Required attribute missing
eval { SQL::Schema::View->new(); };
ok($@||'',"/Missing required attribute `view_name'/");



# Misspelled attribute
eval { SQL::Schema::View->new('vieq_name' => 'foo'); };
ok($@||'',"/Unknown attribute `vieq_name'/");



# Attribute `aliases' not a list reference
eval {
  SQL::Schema::View->new(
    'view_name' => 'foo',
    'subquery'  => 'select x from bar',
    'aliases'   => 'y',
  )
};
ok($@||'',"/Attribute `aliases' needs to be a list reference/");



####################
#
# positive tests
#
####################


# Minimal set of valid attributes
eval {
  ok(
    ref SQL::Schema::View->new(
      'view_name' => 'foo',
      'subquery'  => 'select x from bar',
    ),
    'SQL::Schema::View'
  );
};
ok($@||'','');



# Largest set of valid attributes
eval {
  ok(
    ref SQL::Schema::View->new(
      'view_name'       => 'foo',
      'subquery'        => 'select x from bar',
      'aliases'         => [ 'y' ],
      'constraint_name' => 'check_foo',
    ),
    'SQL::Schema::View'
  );
};
ok($@||'','');



exit(0);
