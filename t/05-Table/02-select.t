#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Table;

require 't/connect.pl';

BEGIN {
  plan tests => 5;
}

my $dbh = Connect::db();



eval { SQL::Schema::Table->select(); };
ok($@||'','/Database handle required by select\(\)/');



eval { SQL::Schema::Table->select('colors'); };
ok($@||'','/Database handle needs to be a reference/');



eval { SQL::Schema::Table->select($dbh); };
ok($@||'','/Table name required by select\(\)/');



{
  my $table = SQL::Schema::Table->select($dbh,'notthere');
  ok(defined($table)?'defined':'undefined','undefined');
}



{
  my $table = SQL::Schema::Table->select($dbh,'colors');
  ok(ref $table, 'SQL::Schema::Table');
}



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
