#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Table::Column;

BEGIN {
  plan tests => 3;
}



{
  my $data_length = SQL::Schema::Table::Column->new(qw(
                      column_name foo
                      data_type   integer
                    ))
                    ->data_length;
  ok(defined($data_length)?'defined':'undefined','undefined');
}



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name foo
    data_type   char
    data_length 17
  ))
  ->data_length,
  17
);



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name foolong
    data_type long
    data_length 0
  ))
  ->data_length,
  0
);



exit(0);
