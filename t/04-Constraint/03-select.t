#  -*- perl -*-

use strict;
use Test;
use SQL::Schema;
use SQL::Schema::Constraint;

require 't/connect.pl';

BEGIN {
  plan tests => 8;
}

my $dbh = Connect::db();



eval { SQL::Schema::Constraint->select(); };
ok($@||'','/Database handle required as first argument/');



eval { SQL::Schema::Constraint->select('x'); };
ok($@||'','/Database handle needs to be a reference/');



eval { SQL::Schema::Constraint->select($dbh); };
ok($@||'','/Constraint name required as second argument/');



# try to select a non existing constraint
{
  my $constraint = SQL::Schema::Constraint->select($dbh,'notthere');
  ok(defined $constraint?'defined':'undefined','undefined');
}



# select a check constraint
ok(
  ref SQL::Schema::Constraint->select($dbh,'pixels_y_range'),
  'SQL::Schema::Constraint'
);



# select a primary key constraint
ok(
  ref SQL::Schema::Constraint->select($dbh,'pixels_pkey'),
  'SQL::Schema::Constraint'
);



# select a unique constraint
ok(
  ref SQL::Schema::Constraint->select($dbh,'colors_skey'),
  'SQL::Schema::Constraint'
);



# select a referential constraint
ok(
  ref SQL::Schema::Constraint->select($dbh,'pixels_ref_colors'),
  'SQL::Schema::Constraint'
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
