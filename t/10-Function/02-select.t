#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Function;

require 't/connect.pl';

BEGIN {
  plan tests => 2;
}

my $dbh = Connect::db();



{
  my $function = SQL::Schema::Function->select($dbh,'notthere');
  ok( defined $function ? 'defined' : 'undefined', 'undefined' );
}



ok(
  ref SQL::Schema::Function->select( $dbh, 'const_pi' ),
  'SQL::Schema::Function'
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
