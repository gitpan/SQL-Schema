#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Trigger;

require 't/connect.pl';

BEGIN {
  plan tests => 5;
}

my $dbh = Connect::db();



eval { SQL::Schema::Trigger->select(); };
ok($@||'','/Database handle required as first argument/');



eval { SQL::Schema::Trigger->select('fake'); };
ok($@||'','/Database handle needs to be a reference/');



eval { SQL::Schema::Trigger->select($dbh); };
ok($@||'','/Trigger name required as second argument/');



{
  my $trigger = SQL::Schema::Trigger->select($dbh,'notthere');
  ok( defined $trigger ? 'defined' : 'undefined', 'undefined' );
}



ok(
  ref SQL::Schema::Trigger->select($dbh,'clip_pixels'),
  'SQL::Schema::Trigger'
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
