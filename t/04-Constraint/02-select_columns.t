#  -*- perl -*-

# depends on SQL::Schema->name to be tested before this test runs
# depends on SQL::Schema::TColumn->name to be tested before this test runs

use strict;
use Test;
use SQL::Schema;
use SQL::Schema::Constraint;

require 't/connect.pl';

BEGIN {
  plan tests => 12;
}

my $dbh = Connect::db();



eval { SQL::Schema::Constraint->select_columns(); };
ok($@||'','/Database handle required as first argument/');



eval { SQL::Schema::Constraint->select_columns('x'); };
ok($@||'','/Database handle needs to be a reference/');



eval { SQL::Schema::Constraint->select_columns($dbh); };
ok($@||'','/Schema name required as second argument/');



eval { SQL::Schema::Constraint->select_columns($dbh,'foo'); };
ok($@||'','/Constraint name required as third argument/');



# try to select columns for non existing constraint
ok(
  scalar SQL::Schema::Constraint->select_columns($dbh,'notthere','notthere'),
  0
);



# select columns for constraint with one column
{
  my @columns = SQL::Schema::Constraint->select_columns(
                   $dbh,
                   SQL::Schema->new($dbh)->name,
                   'colors_pkey',
                );
  ok(scalar @columns,1);
  ok($columns[0]->isa('SQL::Schema::Table::Column'));
}



# select columns for constraint with several columns
{
  my @columns = SQL::Schema::Constraint->select_columns(
                  $dbh,
                  SQL::Schema->new($dbh)->name,
                  'colors_skey',
                );
  ok(scalar @columns,4);
  ok($columns[0]->name,'cyan');
  ok($columns[1]->name,'magenta');
  ok($columns[2]->name,'yellow');
  ok($columns[3]->name,'black');
}



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
