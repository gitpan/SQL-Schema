#  -*- perl -*-

package Connect;

use DBI;

for (qw(DBI_DATA_SOURCE DBI_USERNAME DBI_AUTH)) {
  die "Please set environment $_ as documented within the file INSTALL\n"
    unless exists $ENV{$_};
}

sub db {

  DBI->connect(
    @ENV{qw(DBI_DATA_SOURCE DBI_USERNAME DBI_AUTH)},
    {
      'Warn'        => 1,
      'RaiseError'  => 1,
      'PrintError'  => 1,
      'ChopBlanks'  => 0,
      'AutoCommit'  => 0,
    }
  )
  or die "can't connect to database: $DBI:errstr\n";
}

1;
