#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Table::Column;

BEGIN {
  plan tests => 2;
}



{
  my $data_scale = SQL::Schema::Table::Column->new(qw(
                     column_name  foo
                     data_type    char
                   ))
                   ->data_scale;
  ok(defined($data_scale)?'defined':'undefined','undefined');
}



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name    foo
    data_type      decimal
    data_precision 11
    data_scale     3
  ))
  ->data_scale,
  3
);



exit(0);
