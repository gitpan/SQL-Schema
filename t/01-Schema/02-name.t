#  -*- perl -*-

use strict;
use Test;
use SQL::Schema;

require 't/connect.pl';

BEGIN {
  plan tests => 1;
}

my $dbh = Connect::db();



{
  my $schema_name = SQL::Schema->new($dbh)->name;
  print "Schema name: `$schema_name'\n";
  ok(defined $schema_name?'defined':'undefined','defined');
}



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
