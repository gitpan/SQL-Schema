#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Constraint;

BEGIN {
  plan tests => 28;
}



####################
#
# negative tests
#
####################


# Required attribute missing
eval { SQL::Schema::Constraint->new(); };
ok($@||'',"/Missing required attribute `constraint_name'/");



# Misspelled attribute
eval { SQL::Schema::Constraint->new('constrainr_name' => 'foo'); };
ok($@||'',"/Unknown attribute `constrainr_name'/");



# Attribute `columns' not a list reference
eval {
  SQL::Schema::Constraint->new(qw(
    constraint_name  foo
    constraint_type  P
    columns          noarrayref
  ));
};
ok($@||'',"/Attribute `columns' needs to be a list reference/");



# Unsupported value attribute with defined set of accepted values
eval {
  SQL::Schema::Constraint->new(qw(
    constraint_name  foo
    constraint_type  bar
  ));
};
ok($@||'',"/Unsupported value `BAR' for attribute `constraint_type'/");



# `columns' missing for primary key constraint
eval {
  SQL::Schema::Constraint->new(qw(
    constraint_name  foo
    constraint_type  P
  ));
};
ok($@||'',"/Attribute `columns' required for constraint type P/");



# Unsupported value for attribute `delete_rule'

eval {
  SQL::Schema::Constraint->new(
    qw(
      constraint_name    foo
      constraint_type    R
      delete_rule        cscade
      r_schema           rum
      r_table_name       bar
    ),
    'columns' => [ \'faked column object' ],
    'r_columns' => [ \'faked column object' ],
  );
};
ok($@||'',"/Unsupported value `cscade' for attribute `delete_rule'/");



# Missing attribute `r_schema' for referential constraint
eval {
  SQL::Schema::Constraint->new(
    qw(
      constraint_name    foo
      constraint_type    R
      delete_rule        cascade
      r_table_name       bar
    ),
    'columns' => [ \'faked column object' ],
    'r_columns' => [ \'faked column object' ],
  );
};
ok($@||'',"/Missing attribute `r_schema' for referential constraint/");



# Number of elements for `columns' and `r_columns' need to be equal
eval {
  SQL::Schema::Constraint->new(
    qw(
      constraint_name    foo
      constraint_type    R
      delete_rule        cascade
      r_schema           rum
      r_table_name       bar
    ),
    'columns'   => [ \'faked column object' ],
    'r_columns' => [ \'faked col obj A', \'faked col obj B' ],
  );
};
ok(
  $@||'',
  "/Attributes `columns' and `r_columns' need to be lists of same size/"
);



# Give an attribute to primary key constraint only allowed for referentials
eval {
  SQL::Schema::Constraint->new(
    qw(
      constraint_name    foo
      constraint_type    P
      delete_rule        cascade
    ),
    'columns' => [ \'faked column object' ],
  );
};
ok($@||'',"/Attribute `delete_rule' only allowed for referential constraints/");



# Give a non empty list for `r_columns' for constraint_type != referential
eval {
  SQL::Schema::Constraint->new(
    qw(
      constraint_name    foo
      constraint_type    P
    ),
    'columns' => [ \'faked column object' ],
    'r_columns' => [ \'faked column object' ],
  );
};
ok($@||'',"/Attribute `r_columns' only allowed for referential constraints/");



# Attribute `search_condition' missing for check constraint
eval {
  SQL::Schema::Constraint->new(
    qw(
      constraint_name    foo
      constraint_type    C
    ),
  );
};
ok($@||'',"/Attribute `search_condition' required for constraint type C/");



# Attribute `search_condition' not allowed for non check constraints
eval {
  SQL::Schema::Constraint->new(
    qw(
      constraint_name    foo
      constraint_type    U
    ),
    'columns' => [ \'faked column object' ],
    'search_condition' => 'rum in ( 1, 2 )',
  );
};
ok($@||'',"/Attribute `search_condition' only allowed for check constraints/");



####################
#
# positive tests
#
####################


# Minimal set of valid attributes for check constraint
eval {
  ok(
    ref SQL::Schema::Constraint->new(
      qw(
        constraint_name  foo
        constraint_type  C
      ),
      'search_condition' => 'rum in ( 1, 2 )',
    ),
    'SQL::Schema::Constraint'
  );
};
ok($@||'','');



# Largest set of valid attributes for check constraint
eval {
  ok(
    ref SQL::Schema::Constraint->new(
      'constraint_name'     => 'foo',
      'constraint_type'     => 'C',
      'search_condition'    => 'rum in ( 1, 2 )',
      'status'              => 'enabled',
      'deferrable'          => 'deferrable',
      'deferred'            => 'immediate',
      'generated'           => 'user name',
      'validated'           => 'validated',
    ),
    'SQL::Schema::Constraint'
  );
};
ok($@||'','');



# Minimal set of valid attributes for primary key constraint
eval {
  ok(
    ref SQL::Schema::Constraint->new(
      qw(
        constraint_name  foo
        constraint_type  P
      ),
      'columns' => [ \'faked column object' ],
    ),
    'SQL::Schema::Constraint'
  );
};
ok($@||'','');



# Largest set of valid attributes for primary key constraint
eval {
  ok(
    ref SQL::Schema::Constraint->new(
      'constraint_name'     => 'foo',
      'constraint_type'     => 'P',
      'status'              => 'enabled',
      'deferrable'          => 'deferrable',
      'deferred'            => 'immediate',
      'generated'           => 'user name',
      'validated'           => 'validated',
      'columns'             => [ \'faked column object' ],
    ),
    'SQL::Schema::Constraint'
  );
};
ok($@||'','');



# Minimal set of valid attributes for unique constraint
eval {
  ok(
    ref SQL::Schema::Constraint->new(
      qw(
        constraint_name  foo
        constraint_type  U
      ),
      'columns' => [ \'faked column object' ],
    ),
    'SQL::Schema::Constraint'
  );
};
ok($@||'','');



# Largest set of valid attributes for unique constraint
eval {
  ok(
    ref SQL::Schema::Constraint->new(
      'constraint_name'     => 'foo',
      'constraint_type'     => 'U',
      'status'              => 'enabled',
      'deferrable'          => 'deferrable',
      'deferred'            => 'immediate',
      'generated'           => 'user name',
      'validated'           => 'validated',
      'columns'             => [ \'faked column object' ],
    ),
    'SQL::Schema::Constraint'
  );
};
ok($@||'','');



# Minimal set of valid attributes for referential constraint
eval {
  ok(
    ref SQL::Schema::Constraint->new(
      qw(
        constraint_name    foo
        constraint_type    R
        r_schema           rfoo
        r_table_name       rtable
      ),
      'columns' => [ \'faked column object' ],
      'r_columns' => [ \'faked column object' ],
    ),
    'SQL::Schema::Constraint'
  );
};
ok($@||'','');



# Largest set of valid attributes for referential constraint
eval {
  ok(
    ref SQL::Schema::Constraint->new(
      'constraint_name'     => 'foo',
      'constraint_type'     => 'R',
      'delete_rule'         => 'cascade',
      'status'              => 'enabled',
      'deferrable'          => 'deferrable',
      'deferred'            => 'immediate',
      'generated'           => 'user name',
      'validated'           => 'validated',
      'columns'             => [ \'faked column object' ],
      'r_schema'            => 'rfoo',
      'r_table_name'        => 'rtable',
      'r_columns'           => [ \'faked column object' ],
    ),
    'SQL::Schema::Constraint'
  );
};
ok($@||'','');



exit(0);
