#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Table::Column;

BEGIN {
  plan tests => 3;
}



{
  my $data_default = SQL::Schema::Table::Column->new(qw(
                       column_name foo
                       data_type   integer
                     ))
                     ->data_default;
  ok(defined($data_default)?'defined':'undefined','undefined');
}



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name    foo
    data_type      char
    data_length    20
    data_default   'empty'
  ))
  ->data_default,
  "'empty'"
);



ok(
  SQL::Schema::Table::Column->new(
    qw(
      column_name    foo
      data_type      char
      data_length    20
    ),
    'data_default' => "'empty'\n",
  )
  ->data_default,
  "'empty'"
);



exit(0);
