#  -*- perl -*

use strict;
use Test;
use SQL::Schema::Function;

require 't/connect.pl';

BEGIN {
  plan tests => 3;
}

my $dbh = Connect::db();



ok(
  SQL::Schema::Function->new(
    'name'  => 'const_e',
    'text'  => <<'EOS',
function const_e
  return number
as
begin
  return(2.7182818284590452354);
end;
EOS
  )->create_statement,
  <<'EOS'
create function const_e
  return number
as
begin
  return(2.7182818284590452354);
end;
/
EOS
);



{
  my $function = SQL::Schema::Function->new(
                    'name'  => 'const_e',
                    'text'  => <<'EOS',
function const_e
  return number
as
begin
  return(2.7182818284590452354);
end;
EOS
                  );
  ok("$function",<<'EOS');
create function const_e
  return number
as
begin
  return(2.7182818284590452354);
end;
/
EOS
}



ok(
  SQL::Schema::Function
    ->select($dbh,'const_pi')
      ->create_statement,
  <<'EOS'
create function const_pi
  return number
as
begin
  return(3.14159265358979323846);
end;
/
EOS
);



$dbh->rollback;
$dbh->disconnect;
undef $dbh;

exit(0);
