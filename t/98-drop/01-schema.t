#  -*- perl -*-

use strict;
use Test;

require 't/connect.pl';

BEGIN {
  plan tests => 14;
}

my $dbh = Connect::db();

ok($dbh->do('drop package body constants'),'0E0');
ok($dbh->do('drop package constants'),'0E0');
ok($dbh->do('drop function const_pi'),'0E0');
ok($dbh->do('drop procedure mirror_picture_horizontally'),'0E0');
ok($dbh->do('drop trigger i_pixelcolors'),'0E0');
ok($dbh->do('drop trigger clip_pixels'),'0E0');
ok($dbh->do('drop view colours'),'0E0');
ok($dbh->do('drop view insertable_pixelcolors'),'0E0');
ok($dbh->do('drop view v_pixelcolors'),'0E0');
ok($dbh->do('drop table text_files'),'0E0');
ok($dbh->do('drop table pixels'),'0E0');
ok($dbh->do('drop table colors'),'0E0');
ok($dbh->do('drop sequence nadja'),'0E0');
ok($dbh->do('drop sequence ramona'),'0E0');

$dbh->disconnect;
undef $dbh;

exit(0);
