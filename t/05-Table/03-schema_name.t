#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Table;
use SQL::Schema::Table::Column;

require 't/connect.pl';

BEGIN {
  plan tests => 4;
}

my $dbh = Connect::db();



{
  my $schema_name =
       SQL::Schema::Table->new(
         'table_name'  => 'foo',
         'columns'     => [ SQL::Schema::Table::Column->new(qw(
                              column_name foo
                              data_type   char
                          )) ],
       )
     ->schema_name;
  ok(defined($schema_name)?'defined':'undefined','undefined');
}



ok(
  SQL::Schema::Table->new(
    'schema_name' => 'BAR',
    'table_name'  => 'foo',
    'columns'     => [ SQL::Schema::Table::Column->new(qw(
                         column_name foo
                         data_type   char
                     )) ],
  )
  ->schema_name,
  'BAR'
);



{
  my $schema_name = SQL::Schema::Table->select($dbh,'colors')->schema_name;
  ok(defined($schema_name)?'defined':'undefined','undefined');
}



ok( SQL::Schema::Table->select($dbh,'colors','BAR')->schema_name, 'BAR' );



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
