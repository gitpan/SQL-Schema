#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Package::Body;

require 't/connect.pl';

BEGIN {
  plan tests => 2;
}

my $dbh = Connect::db();



{
  my $body = SQL::Schema::Package::Body->select($dbh,'notthere');
  ok( defined $body ? 'defined' : 'undefined', 'undefined' );
}



ok(
  ref SQL::Schema::Package::Body->select( $dbh, 'constants' ),
  'SQL::Schema::Package::Body'
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
