#  -*- perl -*-

use strict;
use Test;
use SQL::Schema;

require 't/connect.pl';

BEGIN {
  plan tests => 2;
}

my $dbh = Connect::db();

ok(SQL::Schema->new($dbh)->string,'');
{ my $schema = SQL::Schema->new($dbh); ok("$schema",''); }

$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
