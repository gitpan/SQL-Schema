#  -*- perl -*-

use strict;
use Test;
use SQL::Schema::Table::Column;

BEGIN {
  plan tests => 14;
}



eval { SQL::Schema::Table::Column->new(); };
ok($@||'',"/Missing required attribute `column_name'/");



eval { SQL::Schema::Table::Column->new('cloumn_name' => 'foo'); };
ok($@||'',"/Unknown attribute `cloumn_name'/");



eval { SQL::Schema::Table::Column->new('cloumn_name' => 'foo'); };
ok($@||'',"/Unknown attribute `cloumn_name'/");



eval {
  SQL::Schema::Table::Column->new(qw(
    column_name foo
    data_type   char
    data_length x
  ));
};
ok($@||'',"/Value for `data_length' needs to be an integer/");



eval {
  SQL::Schema::Table::Column->new(qw(
    column_name foo
    data_type   integer
    nullable    x
  ));
};
ok($@||'',"/Unsupported value for `nullable'/");



eval {
  SQL::Schema::Table::Column->new(qw(
    column_name     foo
    data_type       number
    data_length     -1
  ));
};
ok($@||'',"/attribute `data_length' needs to be a non negative value/");



eval {
  SQL::Schema::Table::Column->new(qw(
    column_name     foo
    data_type       number
    data_precision  -1
  ));
};
ok($@||'',"/attribute `data_precision' needs to be a non negative value/");



eval {
  SQL::Schema::Table::Column->new(qw(
    column_name     foo
    data_type       number
    data_scale      1
  ));
};
ok(
  $@||'',
  "/attribute `data_scale' requires `data_length' or `data_precision'/"
);



eval {
  ok(
    ref SQL::Schema::Table::Column->new(qw(
          column_name foo
          data_type   integer
        )),
    'SQL::Schema::Table::Column'
  );
};
ok($@||'','');



ok(
  ref SQL::Schema::Table::Column->new(qw(
        column_name foo
        data_type   char
        data_length 17
        nullable    Y
      )),
  'SQL::Schema::Table::Column'
);



ok(
  ref SQL::Schema::Table::Column->new(
        qw(
          column_name  foo
          data_type    char
          data_length  17
          nullable     N
        ),
        'data_default' => "'blabla'",
      ),
  'SQL::Schema::Table::Column'
);



ok(
  ref SQL::Schema::Table::Column->new(qw(
        column_name    foo
        data_type      decimal
        data_precision 7
        data_scale     2
        nullable       N
      )),
  'SQL::Schema::Table::Column'
);



ok(
  ref SQL::Schema::Table::Column->new(qw(
        column_name    foo
        data_type      number
        data_precision 7
        data_scale     0
        nullable       N
      )),
  'SQL::Schema::Table::Column'
);



exit(0);
