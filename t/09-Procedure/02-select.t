#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Procedure;

require 't/connect.pl';

BEGIN {
  plan tests => 2;
}

my $dbh = Connect::db();



{
  my $procedure = SQL::Schema::Procedure->select($dbh,'notthere');
  ok( defined $procedure ? 'defined' : 'undefined', 'undefined' );
}



ok(
  ref SQL::Schema::Procedure->select( $dbh, 'mirror_picture_horizontally' ),
  'SQL::Schema::Procedure'
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
