#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Package;

require 't/connect.pl';

BEGIN {
  plan tests => 2;
}

my $dbh = Connect::db();



{
  my $package = SQL::Schema::Package->select($dbh,'notthere');
  ok( defined $package ? 'defined' : 'undefined', 'undefined' );
}



ok(
  ref SQL::Schema::Package->select( $dbh, 'constants' ),
  'SQL::Schema::Package'
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
