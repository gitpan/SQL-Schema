#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Table::Column;

require 't/connect.pl';

BEGIN {
  plan tests => 14;
}

my $dbh = Connect::db();



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name   foo
    data_type     integer
  ))
  ->column_definition,
  'foo integer'
);



{
  my $column = SQL::Schema::Table::Column->new(qw(
                 column_name   foo
                 data_type     integer
               ));
  ok("$column",'foo integer');
}



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name   foo
    data_type     integer
    nullable      n
  ))
  ->column_definition,
  'foo integer not null'
);



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name   foo
    data_type     char
    data_length   11
  ))
  ->column_definition,
  'foo char(11)'
);



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name     foo
    data_type       decimal
    data_precision  7
  ))
  ->column_definition,
  'foo decimal(7)'
);



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name     foo
    data_type       decimal
    data_precision  7
    data_default    3334
  ))
  ->column_definition,
  'foo decimal(7) default 3334'
);



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name     foo
    data_type       decimal
    data_precision  5
    data_scale      2
  ))
  ->column_definition,
  'foo decimal(5,2)'
);



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name     foo
    data_type       number
    data_length     22
    data_scale      0
  ))
  ->column_definition,
  'foo number(22,0)'
);



ok(
  SQL::Schema::Table::Column->new(qw(
    column_name   foo
    data_type     long
    data_length   0
  ))
  ->column_definition,
  'foo long'
);



ok(
  SQL::Schema::Table::Column->select($dbh,'colors','cyan')->column_definition,
  'cyan number(22,0) default 7'
);



ok(
  SQL::Schema::Table::Column->select($dbh,'colors','magenta')
    ->column_definition,
  'magenta char(7) not null'
);



ok(
  SQL::Schema::Table::Column->select($dbh,'colors','yellow')->column_definition,
  'yellow number(11,3)'
);



ok(
  SQL::Schema::Table::Column->select($dbh,'colors','black')->column_definition,
  'black number(22,0)'
);



ok(
  SQL::Schema::Table::Column->select($dbh,'text_files','text')
    ->column_definition,
  q(text long default 'empty')
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
