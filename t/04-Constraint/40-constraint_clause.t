#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Constraint;
use SQL::Schema::Table::Column;

require 't/connect.pl';

BEGIN {
  plan tests => 16;
}

my $dbh = Connect::db();



#####################
#  check constraint
#####################

ok(
  SQL::Schema::Constraint->new(
    'constraint_name'     => 'foo',
    'constraint_type'     => 'C',
    'search_condition'    => 'rum in ( 1, 2 )',
    'status'              => 'enabled',
    'deferrable'          => 'deferrable',
    'deferred'            => 'immediate',
    'generated'           => 'user name',
    'validated'           => 'validated',
  )->constraint_clause . "\n",
  <<'EOC',
constraint foo check (rum in ( 1, 2 ))
deferrable initially immediate
enable validate
EOC
);



{
  my $constraint = SQL::Schema::Constraint->new(
    'constraint_name'     => 'foo',
    'constraint_type'     => 'C',
    'search_condition'    => 'rum in ( 1, 2 )',
    'status'              => 'enabled',
    'deferrable'          => 'deferrable',
    'deferred'            => 'immediate',
    'generated'           => 'user name',
    'validated'           => 'validated',
  );
  ok( "$constraint\n", <<'EOC' );
constraint foo check (rum in ( 1, 2 ))
deferrable initially immediate
enable validate
EOC
}



ok(
  SQL::Schema::Constraint->new(
    'constraint_name'     => 'foo',
    'constraint_type'     => 'C',
    'search_condition'    => 'rum in ( 1, 2 )',
    'status'              => 'enabled',
    'deferrable'          => 'deferrable',
    'deferred'            => 'immediate',
    'generated'           => 'generated name',
    'validated'           => 'validated',
  )->constraint_clause . "\n",
  <<'EOC',
check (rum in ( 1, 2 ))
deferrable initially immediate
enable validate
EOC
);



ok(
  SQL::Schema::Constraint
    ->select($dbh,'pixels_y_range')
      ->constraint_clause . "\n",
  <<'EOC',
constraint pixels_y_range check ( 0 <= y and y < 768 )
not deferrable initially immediate
enable validate
EOC
);



###########################
#  primary key constraint
###########################

ok(
  SQL::Schema::Constraint->new(
    'constraint_name'     => 'foo',
    'constraint_type'     => 'P',
    'status'              => 'enabled',
    'deferrable'          => 'not deferrable',
    'deferred'            => 'immediate',
    'generated'           => 'user name',
    'validated'           => 'validated',
    'columns'             => [
                               SQL::Schema::Table::Column->new(qw(
                                 column_name   one
                                 data_type     integer
                               )),
                               SQL::Schema::Table::Column->new(qw(
                                 column_name   two
                                 data_type     integer
                               )),
                             ],
  )->constraint_clause . "\n",
  <<'EOC',
constraint foo primary key (
  one,
  two
)
not deferrable initially immediate
enable validate
EOC
);



{
  my $constraint = SQL::Schema::Constraint->new(
    'constraint_name'     => 'foo',
    'constraint_type'     => 'P',
    'status'              => 'enabled',
    'deferrable'          => 'not deferrable',
    'deferred'            => 'immediate',
    'generated'           => 'user name',
    'validated'           => 'validated',
    'columns'             => [
                               SQL::Schema::Table::Column->new(qw(
                                 column_name   one
                                 data_type     integer
                               )),
                               SQL::Schema::Table::Column->new(qw(
                                 column_name   two
                                 data_type     integer
                               )),
                             ],
  );
  ok( "$constraint\n", <<'EOC' );
constraint foo primary key (
  one,
  two
)
not deferrable initially immediate
enable validate
EOC
}



ok(
  SQL::Schema::Constraint->new(
    'constraint_name'     => 'foo',
    'constraint_type'     => 'P',
    'status'              => 'enabled',
    'deferrable'          => 'not deferrable',
    'deferred'            => 'immediate',
    'generated'           => 'generated name',
    'validated'           => 'validated',
    'columns'             => [
                               SQL::Schema::Table::Column->new(qw(
                                 column_name   one
                                 data_type     integer
                               )),
                             ],
  )->constraint_clause . "\n",
  <<'EOC',
primary key (
  one
)
not deferrable initially immediate
enable validate
EOC
);



ok(
  SQL::Schema::Constraint
    ->select($dbh,'colors_pkey')
      ->constraint_clause . "\n",
  <<'EOC',
constraint colors_pkey primary key (
  id
)
not deferrable initially immediate
enable validate
EOC
);



######################
#  unique constraint
######################

ok(
  SQL::Schema::Constraint->new(
    'constraint_name'     => 'foo',
    'constraint_type'     => 'U',
    'status'              => 'enabled',
    'deferrable'          => 'deferrable',
    'deferred'            => 'immediate',
    'generated'           => 'user name',
    'validated'           => 'validated',
    'columns'             => [
                               SQL::Schema::Table::Column->new(qw(
                                 column_name   one
                                 data_type     integer
                               )),
                               SQL::Schema::Table::Column->new(qw(
                                 column_name   two
                                 data_type     integer
                               )),
                             ],
  )->constraint_clause . "\n",
  <<'EOC',
constraint foo unique (
  one,
  two
)
deferrable initially immediate
enable validate
EOC
);



{
  my $constraint = SQL::Schema::Constraint->new(
    'constraint_name'     => 'foo',
    'constraint_type'     => 'U',
    'status'              => 'enabled',
    'deferrable'          => 'deferrable',
    'deferred'            => 'immediate',
    'generated'           => 'user name',
    'validated'           => 'validated',
    'columns'             => [
                               SQL::Schema::Table::Column->new(qw(
                                 column_name   one
                                 data_type     integer
                               )),
                               SQL::Schema::Table::Column->new(qw(
                                 column_name   two
                                 data_type     integer
                               )),
                             ],
  );
  ok( "$constraint\n", <<'EOC' );
constraint foo unique (
  one,
  two
)
deferrable initially immediate
enable validate
EOC
}



ok(
  SQL::Schema::Constraint->new(
    'constraint_name'     => 'foo',
    'constraint_type'     => 'U',
    'status'              => 'enabled',
    'deferrable'          => 'deferrable',
    'deferred'            => 'immediate',
    'generated'           => 'generated name',
    'validated'           => 'validated',
    'columns'             => [
                               SQL::Schema::Table::Column->new(qw(
                                 column_name   one
                                 data_type     integer
                               )),
                             ],
  )->constraint_clause . "\n",
  <<'EOC',
unique (
  one
)
deferrable initially immediate
enable validate
EOC
);



ok(
  SQL::Schema::Constraint
    ->select($dbh,'colors_skey')
      ->constraint_clause . "\n",
  <<'EOC',
constraint colors_skey unique (
  cyan,
  magenta,
  yellow,
  black
)
not deferrable initially immediate
enable validate
EOC
);



###########################
#  referential constraint
###########################

{
  my $constraint = SQL::Schema::Constraint->new(
    'constraint_name'     => 'foo',
    'constraint_type'     => 'R',
    'delete_rule'         => 'cascade',
    'status'              => 'enabled',
    'deferrable'          => 'deferrable',
    'deferred'            => 'immediate',
    'generated'           => 'user name',
    'validated'           => 'validated',
    'columns'             => [
                               SQL::Schema::Table::Column->new(qw(
                                 column_name   one
                                 data_type     integer
                               )),
                             ],
    'r_schema'            => 'rfoo',
    'r_table_name'        => 'rtable',
    'r_columns'           => [
                               SQL::Schema::Table::Column->new(qw(
                                 column_name   rone
                                 data_type     integer
                               )),
                             ],
  );
  my $expected = <<'EOC';
constraint foo foreign key (
  one
)
references rfoo.rtable (
  rone
)
on delete cascade
deferrable initially immediate
enable validate
EOC

  ok($constraint->constraint_clause . "\n",$expected);
  ok("$constraint\n",$expected);
}



ok(
  SQL::Schema::Constraint->new(
    'constraint_name'     => 'foo',
    'constraint_type'     => 'R',
    'status'              => 'enabled',
    'deferrable'          => 'deferrable',
    'deferred'            => 'immediate',
    'generated'           => 'generated name',
    'validated'           => 'validated',
    'columns'             => [
                               SQL::Schema::Table::Column->new(qw(
                                 column_name   one
                                 data_type     integer
                               )),
                               SQL::Schema::Table::Column->new(qw(
                                 column_name   two
                                 data_type     integer
                               )),
                             ],
    'r_schema'            => 'rfoo',
    'r_table_name'        => 'rtable',
    'r_columns'           => [
                               SQL::Schema::Table::Column->new(qw(
                                 column_name   rone
                                 data_type     integer
                               )),
                               SQL::Schema::Table::Column->new(qw(
                                 column_name   rtwo
                                 data_type     integer
                               )),
                             ],
  )->constraint_clause . "\n",
  <<'EOC',
foreign key (
  one,
  two
)
references rfoo.rtable (
  rone,
  rtwo
)
deferrable initially immediate
enable validate
EOC
);



ok(
  SQL::Schema::Constraint
    ->select($dbh,'pixels_ref_colors')
      ->constraint_clause . "\n",
  <<'EOC',
constraint pixels_ref_colors foreign key (
  color_id
)
references sql_test.colors (
  id
)
on delete cascade
not deferrable initially immediate
enable validate
EOC
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
