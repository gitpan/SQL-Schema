#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Source;

require 't/connect.pl';

BEGIN {
  plan tests => 6;
}

my $dbh = Connect::db();



eval { SQL::Schema::Source->select(); };
ok($@||'','/Database handle required as first argument/');



eval { SQL::Schema::Source->select('fake'); };
ok($@||'','/Database handle needs to be a reference/');



eval { SQL::Schema::Source->select($dbh); };
ok($@||'','/Source name required as second argument/');



eval { SQL::Schema::Source->select($dbh,'mirror_picture_horizontally'); };
ok($@||'','/Source type required as third argument/');



{
  my $source = SQL::Schema::Source->select($dbh,'notthere','procedure');
  ok( defined $source ? 'defined' : 'undefined', 'undefined' );
}



ok(
  ref SQL::Schema::Source->select(
    $dbh,
    'mirror_picture_horizontally',
    'procedure',
  ),
  'SQL::Schema::Source'
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
