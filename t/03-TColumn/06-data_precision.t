#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Table::Column;

BEGIN {
  plan tests => 2;
}



{
  my $data_precision = SQL::Schema::Table::Column->new(qw(
                         column_name foo
                         data_type   integer
                       ))
                       ->data_precision;
  ok(defined($data_precision)?'defined':'undefined','undefined');
}



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name    foo
    data_type      decimal
    data_precision 11
    data_scale     3
  ))
  ->data_precision,
  11
);



exit(0);
