#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::View;

require 't/connect.pl';

BEGIN {
  plan tests => 5;
}

my $dbh = Connect::db();



eval { SQL::Schema::View->select(); };
ok($@||'','/Database handle required as first argument/');



eval { SQL::Schema::View->select('fake'); };
ok($@||'','/Database handle needs to be a reference/');



eval { SQL::Schema::View->select($dbh); };
ok($@||'','/View name required as second argument/');



{
  my $view = SQL::Schema::View->select($dbh,'notthere');
  ok( defined $view ? 'defined' : 'undefined', 'undefined' );
}



ok( ref SQL::Schema::View->select($dbh,'colours'), 'SQL::Schema::View' );



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
