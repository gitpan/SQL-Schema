#                              -*- Mode: CPerl -*-
#
#  $Source: lib/SQL/Schema/Table.pm $
#  $Id: Table.pm 1.7 Tue, 11 Apr 2000 00:40:37 +0200 the $
#  $ProjectHeader: SQL-Schema 0.31 Tue, 25 Apr 2000 23:27:34 +0200 todd $

#
#  (C) Copyright 2000, Torsten Hentschel
#                      Windmuehlenweg 47
#                      44141 Dortmund
#                      Germany
#
#                      Email: todd@bayleys.ping.de
#
#  All rights reserved.
#
#  You may distribute this package under the terms of either the GNU
#  General Public License or the Artistic License, as specified in the
#  Perl README file.
#



package SQL::Schema::Table;

require 5.005;

use SQL::Schema::Constraint;
use SQL::Schema::Table::Column;

use strict;
use vars qw($VERSION);
use Carp;

# $Format: "\$VERSION = $ProjectMajorVersion$.$ProjectMinorVersion$;"$
$VERSION = 0.31;



=pod

=head1 NAME

SQL::Schema::Table - A database table


=head1 SYNOPSIS

  my $table = SQL::Schema::Table->new(%attr);

  my $sql = $table->create_statement;
  print $sql;

  print "$table";


=head1 DESCRIPTION

C<SQL::Schema::Table> is a class for objects representing a database
table. The methods of an instanciated object do allow to access the
information within a database's data dictionary and to represent them as SQL
create statements and the like using the proper SQL dialect.

=cut



############################################################################
#
#  new()
#
############################################################################

=pod

=head2 Constructors

  $table = SQL::Schema::Table->new(%attr);

The B<new> method instanciates a table object. The object is
an in memory representation of a (possible) database table.
The attributes are given as key value pairs by the hash C<%attr>.
Possible keys are:

  key              required?   value description

  schema_name      no          The name of the schema for

  table_name       yes         The name of the table (without a
                               preceeding schema name).

  columns          yes         a reference to a list of
                               column objects

  pct_free         no          number
  pct_used         no          number
  ini_trans        no          number

These keys (except C<schema_name> and C<columns>) and their
possible values correspond exactly to the data dictionary view
C<user_tables> and are described within Oracle's Server Reference.

Optionally the following keys and values which do have no counter part
within the view C<user_tables> are allowed for the attribute hash:

  key           value description

  constraints   a reference to a list of constraint objects
                (objects of type SQL::Schema::Constraint for instance)

=cut

my @seq_self = qw(schema_name table_name columns pct_free pct_used ini_trans
                  constraints);
my $struct_self = {};
for (my $i = 0; $i < @seq_self; $i++) { $struct_self->{$seq_self[$i]} = $i+1;}

sub new {

  my ($this,%attr) = @_;

  for (keys %attr) {
    croak("Unknown attribute `$_'") unless $struct_self->{$_};
  }
  for (qw(table_name columns)) {
    croak("Missing required attribute `$_'") unless defined $attr{$_};
  }

  my $self = [ $struct_self, @attr{@seq_self} ];
  $self->{'constraints'} ||= [];
  for (qw(columns constraints)) {
    croak("Attribute `$_' needs to be an array reference")
      unless 'ARRAY' eq ref $self->{$_};
  }
  croak("At least one column is required")
    unless @{$self->{'columns'}};
  for (qw(pct_free pct_used ini_trans)) {
    next unless defined $self->{$_};
    croak("Value for `$_' needs to be a positive integer or zero")
      unless $self->{$_} =~ /^[+]?\d{1,38}$/;
  }


  bless($self,ref $this || $this);

}



############################################################################
#
#  select()
#
############################################################################

=pod

  $table = SQL::Schema::Table->select($dbh,$name,$schema_name);

The B<select> method fetches the attributes required by B<new>
from the database and returns the table object. (It calls B<new>
internally.)

If the table with the name C<$name> could not be found within
the database, the method returns undef.

The method's arguments are as follows:

=over

=item C<$dbh>

A database handle as defined by L<DBI(3)>.

=item C<$name>

The name of the table without preceeding schema name.

=item C<$schema_name>

The name of the database schema.

=back

=cut

sub select {
  my ($this,$dbh,$table_name,$schema_name) = @_;

  croak("Database handle required by select()") unless $dbh;
  croak("Database handle needs to be a reference") unless ref $dbh;
  croak("Table name required by select()") unless $table_name;

  my $sth = $dbh->prepare_cached(<<'EOS');
select
    pct_free,
    pct_used,
    ini_trans
  from
    user_tables
  where
    table_name = upper(?)
EOS
  my $tbl = $dbh->selectall_arrayref($sth,{},$table_name);

  return unless @$tbl;

  die "Error: Query returned unexpected number of rows and / or columns."
    unless 1 == @$tbl && 3 == @{$tbl->[0]};

  my %attr = ( 'schema_name' => $schema_name, 'table_name' => $table_name );
  @attr{qw(pct_free pct_used ini_trans)} = @{$tbl->[0]};
  $attr{'columns'} = [
    map { SQL::Schema::Table::Column->select($dbh,$table_name,@$_) }
      @{$dbh->selectall_arrayref($dbh->prepare_cached(<<'EOS'),{},$table_name)}
select lower(column_name) from user_tab_columns where table_name = upper(?)
  order by column_id
EOS
  ];
  die "Error: Did find no columns for this table."
    unless @{$attr{'columns'}};
  $attr{'constraints'} = [
    map { SQL::Schema::Constraint->select($dbh,@$_) }
      @{$dbh->selectall_arrayref($dbh->prepare_cached(<<'EOS'),{},$table_name)}
select lower(constraint_name) from user_constraints
  where table_name = upper(?)
  order by 1
EOS
  ];

  return $this->new(%attr);
}



############################################################################
#
#  attribute methods
#
############################################################################

=pod

=head2 Methods

The following attribute methods do return the current value
of the attributes (as handed over to the B<new> method):

  $schema_name = $table->schema_name;
  $name = $table->name;
  @columns = $table->columns;
  $pct_free = $table->pct_free;
  $pct_used = $table->pct_used;
  $ini_trans = $table->ini_trans;
  @constraints = $table->constraints;

=cut

sub schema_name  { $_[0]->{'schema_name'};    }
sub name         { $_[0]->{'table_name'};     }
sub columns      { @{$_[0]->{'columns'}};     }
sub pct_free     { $_[0]->{'pct_free'};       }
sub pct_used     { $_[0]->{'pct_used'};       }
sub ini_trans    { $_[0]->{'ini_trans'};      }
sub constraints  { @{$_[0]->{'constraints'}}; }



############################################################################
#
#  qualified_name()
#
############################################################################

=pod

  my $qname = $table->qualified_name;

Returns the qualified name of the table which is the concatenation
of C<schema_name> and C<table_name> with a in between if C<schema_name>
has been set. Otherwise only C<table_name> is returned.

=cut

sub qualified_name {
  $_[0]->schema_name
    ? $_[0]->schema_name . '.' . $_[0]->name
    : $_[0]->name;
}



############################################################################
#
#  create_statement()
#
############################################################################

=pod

  $sql = $table->create_statement;
  $sql = "$table";

Returns a string containing an SQL statements for creation of this
table. This method is overloaded with the string operator.
So the two examples above are equivalent.

=cut

use overload '""' => \&create_statement;

sub create_statement {

  my $self = $_[0];

  my $sql = 'create table ' . $self->qualified_name . " (\n";
  my @constraints                            # QUICK HACK to get rid of
    = grep {!($_->generated_b &&          # the duplication for
              $_->type eq 'C' &&
              $_->columns == 1 &&
              $_->search_condition
              eq sprintf('"%s" IS NOT NULL', map { uc $_->name } $_->columns))}
      $self->constraints;
  $sql .= join(",\n", (map { "  $_" } $self->columns),
                      (map { "$_" } @constraints));
  $sql .= "\n)\n";
  $sql .= "  pctfree " . $self->pct_free . "\n" if defined $self->pct_free;
  $sql .= "  pctused " . $self->pct_used . "\n" if defined $self->pct_used;
  $sql .= "  initrans " . $self->ini_trans . "\n" if defined $self->ini_trans;
  chomp $sql;
  $sql .= ";\n";

  return $sql;
}



############################################################################
#
#  drop_statement()
#
############################################################################

=pod

  $sql = $table->drop_statement;

Returns a string containing an SQL statement that would drop this
table.

=cut

sub drop_statement { 'drop table ' . $_[0]->qualified_name . ";\n"; }



1;

__END__

=pod

=head1 AUTHOR AND COPYRIGHT

  SQL::Schema::Table is Copyright (C) 2000,
    Torsten Hentschel
    Windmuehlenweg 47
    44141 Dortmund
    Germany

    Email: todd@bayleys.ping.de

  All rights reserved.

  You may distribute this package under the terms of either the GNU
  General Public License or the Artistic License, as specified in the
  Perl README file.


=head1 SEE ALSO

L<DBI(3)>,
L<SQL::Schema(3)>,
L<SQL::Schema::Table::Column(3)>,
L<SQL::Schema::Constraint(3)>

=cut
