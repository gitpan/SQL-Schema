#  -*- perl -*-

use strict;
use Test;
use SQL::Schema;

require 't/connect.pl';

BEGIN {
  plan tests => 4;
}

my $dbh = Connect::db();



eval { SQL::Schema->new(); };
ok($@||'','/Database handle required for constructor new\(\)/');



eval { SQL::Schema->new('foo'); };
ok($@||'','/Database handle needs to be an object reference/');



eval { ok(ref SQL::Schema->new($dbh),'SQL::Schema'); };
ok($@||'','');



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
