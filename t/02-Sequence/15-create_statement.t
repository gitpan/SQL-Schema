#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Sequence;

require 't/connect.pl';

BEGIN {
  plan tests => 11;
}

my $dbh = Connect::db();



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   3
    cache_size     0
    start_with     5
  ))
  ->create_statement,
  <<'EOS',
create sequence foo
  increment by 3
  nocycle
  noorder
  nocache
  start with 5;
EOS
);



ok(
  SQL::Schema::Sequence->new(qw(
    schema_name    bar
    sequence_name  foo
    increment_by   3
    cache_size     0
    start_with     5
  ))
  ->create_statement,
  <<'EOS',
create sequence bar.foo
  increment by 3
  nocycle
  noorder
  nocache
  start with 5;
EOS
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   10000000000000000000000000000000000003
    cache_size     200
    start_with     20000000000000000000000000000000000001
  ))
  ->create_statement,
  <<'EOS',
create sequence foo
  increment by 10000000000000000000000000000000000003
  nocycle
  noorder
  cache 200
  start with 20000000000000000000000000000000000001;
EOS
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   3
    cache_size     7
    start_with     5
    min_value      -11
  ))
  ->create_statement,
  <<'EOS',
create sequence foo
  minvalue -11
  increment by 3
  nocycle
  noorder
  cache 7
  start with 5;
EOS
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   3
    cache_size     7
    start_with     5
    max_value      11
  ))
  ->create_statement,
  <<'EOS',
create sequence foo
  maxvalue 11
  increment by 3
  nocycle
  noorder
  cache 7
  start with 5;
EOS
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   3
    cache_size     7
    start_with     5
    cycle_flag     Y
  ))
  ->create_statement,
  <<'EOS',
create sequence foo
  increment by 3
  cycle
  noorder
  cache 7
  start with 5;
EOS
);



ok(
  SQL::Schema::Sequence->new(qw(
    sequence_name  foo
    increment_by   3
    cache_size     7
    start_with     5
    order_flag     Y
  ))
  ->create_statement,
  <<'EOS',
create sequence foo
  increment by 3
  nocycle
  order
  cache 7
  start with 5;
EOS
);



ok(
  SQL::Schema::Sequence->new(qw(
    schema_name    bar
    sequence_name  foo
    increment_by   3
    cache_size     7
    start_with     5
    cycle_flag     Y
    order_flag     Y
    min_value      -1
    max_value      11
  ))
  ->create_statement,
  <<'EOS',
create sequence bar.foo
  minvalue -1
  maxvalue 11
  increment by 3
  cycle
  order
  cache 7
  start with 5;
EOS
);



{
  my $sequence = SQL::Schema::Sequence->new(qw(
    schema_name    bar
    sequence_name  foo
    increment_by   3
    cache_size     7
    start_with     5
    cycle_flag     Y
    order_flag     Y
    min_value      -1
    max_value      11
  ));
  ok("$sequence",<<'EOS');
create sequence bar.foo
  minvalue -1
  maxvalue 11
  increment by 3
  cycle
  order
  cache 7
  start with 5;
EOS
}



ok(
  SQL::Schema::Sequence->select($dbh,'ramona')->create_statement,
  <<'EOS',
create sequence ramona
  minvalue 1
  maxvalue 999999999999999999999999999
  increment by 1
  nocycle
  noorder
  cache 20
  start with 2;
EOS
);



ok(
  SQL::Schema::Sequence->select($dbh,'ramona','bar')->create_statement,
  <<'EOS',
create sequence bar.ramona
  minvalue 1
  maxvalue 999999999999999999999999999
  increment by 1
  nocycle
  noorder
  cache 20
  start with 2;
EOS
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
