#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Sequence;

require 't/connect.pl';

BEGIN {
  plan tests => 5;
}

my $dbh = Connect::db();



eval { SQL::Schema::Sequence->select(); };
ok($@||'','/Database handle required by select\(\)/');



eval { SQL::Schema::Sequence->select('ramona'); };
ok($@||'','/Database handle needs to be a reference/');



eval { SQL::Schema::Sequence->select($dbh); };
ok($@||'','/Sequence name required by select()/');



{
  my $sequence = SQL::Schema::Sequence->select($dbh,'notthere');
  ok(defined($sequence)?'defined':'undefined','undefined');
}



{
  my $sequence = SQL::Schema::Sequence->select($dbh,'ramona');
  ok(ref $sequence, 'SQL::Schema::Sequence');
}



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
