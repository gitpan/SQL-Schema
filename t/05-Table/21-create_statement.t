#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Constraint;
use SQL::Schema::Table;
use SQL::Schema::Table::Column;

require 't/connect.pl';

BEGIN {
  plan tests => 6;
}

my $dbh = Connect::db();



ok(
  SQL::Schema::Table->new(
    'schema_name' => 'nina',
    'table_name' => 'pinta',
    'columns' => [ SQL::Schema::Table::Column->new(qw(
                   column_name maria
                   data_type   char
                 )) ],
  )->create_statement,
  <<'EOS',
create table nina.pinta (
  maria char
);
EOS
);



{
  my $table = SQL::Schema::Table->new(
                'schema_name' => 'nina',
                'table_name' => 'pinta',
                'columns' => [ SQL::Schema::Table::Column->new(qw(
                               column_name maria
                               data_type   char
                             )) ],
              );
  ok( "$table", <<'EOS' );
create table nina.pinta (
  maria char
);
EOS
}



ok(
  SQL::Schema::Table->new(
    'table_name' => 'sandra',
    'columns' => [
                   SQL::Schema::Table::Column->new(qw(
                     column_name maximilian
                     data_type   char
                   )),
                   SQL::Schema::Table::Column->new(qw(
                     column_name heinrich
                     data_type   number
                     data_length 22
                     data_scale  0
                   )),
                   SQL::Schema::Table::Column->new(qw(
                     column_name helmut
                     data_type   char
                     data_length 17
                     nullable    N
                   )),
                 ],
    'pct_free' => 17,
    'pct_used' => 86,
    'ini_trans' => 5,
  )->create_statement,
  <<'EOS',
create table sandra (
  maximilian char,
  heinrich number(22,0),
  helmut char(17) not null
)
  pctfree 17
  pctused 86
  initrans 5;
EOS
);



ok(
  SQL::Schema::Table->new(
    'schema_name' => 'nina',
    'table_name' => 'pinta',
    'columns' => [ SQL::Schema::Table::Column->new(qw(
                   column_name maria
                   data_type   char
                 )) ],
    'constraints' => [ SQL::Schema::Constraint->new(
                       'constraint_name' => 'nina_maria_check_bool',
                       'constraint_type' => 'C',
                       'search_condition' => "maria in ('T','F')",
                     ) ],
  )->create_statement,
  <<'EOS',
create table nina.pinta (
  maria char,
constraint nina_maria_check_bool check (maria in ('T','F'))
not deferrable initially immediate
enable validate
);
EOS
);



ok(
  SQL::Schema::Table->new(
    'schema_name' => 'nina',
    'table_name' => 'pinta',
    'columns' => [ SQL::Schema::Table::Column->new(qw(
                   column_name maria
                   data_type   char
                 )) ],
    'constraints' => [ SQL::Schema::Constraint->new(
                       'constraint_name' => 'nina_maria_check_bool',
                       'constraint_type' => 'C',
                       'search_condition' => "maria in ('T','F')",
                       ),
                       SQL::Schema::Constraint->new(
                       'constraint_name' => 'nina_maria_unique',
                       'constraint_type' => 'U',
                       'columns' => [ SQL::Schema::Table::Column->new(qw(
                                      column_name maria
                                      data_type   char
                                    )) ],
                     ) ],
  )->create_statement,
  <<'EOS',
create table nina.pinta (
  maria char,
constraint nina_maria_check_bool check (maria in ('T','F'))
not deferrable initially immediate
enable validate,
constraint nina_maria_unique unique (
  maria
)
not deferrable initially immediate
enable validate
);
EOS
);



ok(
  SQL::Schema::Table->select($dbh,'colors')->create_statement,
  <<'EOS',
create table colors (
  id number(22,0) not null,
  cyan number(22,0) default 7,
  magenta char(7) not null,
  yellow number(11,3),
  black number(22,0),
constraint colors_pkey primary key (
  id
)
not deferrable initially immediate
enable validate,
constraint colors_skey unique (
  cyan,
  magenta,
  yellow,
  black
)
not deferrable initially immediate
enable validate
)
  pctfree 10
  pctused 40
  initrans 1;
EOS
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
