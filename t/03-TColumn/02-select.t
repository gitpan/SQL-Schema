#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Table::Column;

require 't/connect.pl';

BEGIN {
  plan tests => 6;
}

my $dbh = Connect::db();



eval { SQL::Schema::Table::Column->select(); };
ok($@||'',"/Database handle required by select\(\)/");



eval { SQL::Schema::Table::Column->select('colors'); };
ok($@||'',"/Database handle needs to be a reference/");



eval { SQL::Schema::Table::Column->select($dbh); };
ok($@||'',"/Table name required by select()/");



eval { SQL::Schema::Table::Column->select($dbh,'colors'); };
ok($@||'',"/Column name required by select()/");



{
  my $column = SQL::Schema::Table::Column->select($dbh,'notthere','nocolumn');
  ok(defined($column)?'defined':'undefined','undefined');
}



{
  my $column = SQL::Schema::Table::Column->select($dbh,'colors','cyan');
  ok(ref $column, 'SQL::Schema::Table::Column');
}



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
