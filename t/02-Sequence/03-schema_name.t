#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Sequence;

require 't/connect.pl';

BEGIN {
  plan tests => 4;
}

my $dbh = Connect::db();



{
  my $schema_name =
       SQL::Schema::Sequence->new(qw(
         sequence_name  foo
         increment_by   1
         cache_size     0
         start_with     1
       ))
     ->schema_name;
  ok(defined($schema_name)?'defined':'undefined','undefined');
}



ok(
    SQL::Schema::Sequence->new(qw(
      schema_name    BAR
      sequence_name  foo
      increment_by   1
      cache_size     0
      start_with     1
    ))
    ->schema_name,
   'BAR'
);



{
  my $schema_name = SQL::Schema::Sequence->select($dbh,'ramona')->schema_name;
  ok(defined($schema_name)?'defined':'undefined','undefined');
}



ok( SQL::Schema::Sequence->select($dbh,'ramona','BAR')->schema_name, 'BAR' );



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
