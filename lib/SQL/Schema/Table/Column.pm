#                              -*- Mode: CPerl -*-
#
#  $Source: lib/SQL/Schema/Table/Column.pm $
#  $Id: Column.pm 1.9 Mon, 24 Apr 2000 17:57:38 +0200 todd $
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



package SQL::Schema::Table::Column;

require 5.005;

use strict;
use vars qw($VERSION);
use Carp;

# $Format: "\$VERSION = $ProjectMajorVersion$.$ProjectMinorVersion$;"$
$VERSION = 0.31;



=pod

=head1 NAME

SQL::Schema::Table::Column - A column of a database table


=head1 SYNOPSIS

  my $column = SQL::Schema::Table::Column->new(%attr);

  my $sql = $column->column_definition;
  print $sql;

  print "$column";


=head1 DESCRIPTION

C<SQL::Schema::Table::Column> is a class for objects representing a database
table's column. The methods of an instanciated object do allow to access the
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

  $column = SQL::Schema::Table::Column->new(%attr);

The B<new> method instanciates a column object. The object is
an in memory representation of a (possible) database table's column.
The attributes are given as key value pairs by the hash C<%attr>.
Possible keys are:

  key              required?   value description

  column_name      yes         The name of the table's column.

  data_type        yes         number
  data_length      no          number
  data_precision   no          number
  data_scale       no          number
  nullable         no          either `Y' o `N'; default: `Y'
  data_default     no          a character string approbriate as
                               expression after the `default' keyword
                               (might include quotes)

These keys and their possible values correspond exactly to the
data dictionary view C<all_tab_columns> and are described within
Oracle's Server Reference.

=cut

my @seq_self = qw(column_name
                  data_type data_length data_precision data_scale
                  nullable data_default);
my $struct_self = {};
for (my $i = 0; $i < @seq_self; $i++) { $struct_self->{$seq_self[$i]} = $i+1;}

sub new {

  my ($this,%attr) = @_;

  for (keys %attr) {
    croak("Unknown attribute `$_'") unless $struct_self->{$_};
  }
  for (qw(column_name data_type)) {
    croak("Missing required attribute `$_'") unless defined $attr{$_};
  }

  my $self = [ $struct_self, @attr{@seq_self} ];
  for (qw(data_length data_precision data_scale)) {
    next unless defined $self->{$_};
    croak("Value for `$_' needs to be an integer")
      unless $self->{$_} =~ /^[-+]?\d{1,38}$/;
  }
  for (qw(nullable)) {
    $self->{$_} ||= 'Y';
    $self->{$_} = uc $self->{$_};
    croak("Unsupported value for `$_'") unless $self->{$_} eq 'Y'
                                            || $self->{$_} eq 'N';
  }
  for (qw(data_length data_precision)) {
    croak("attribute `$_' needs to be a non negative value")
      if defined $self->{$_} && $self->{$_} < 0;
  }
  croak("attribute `data_scale' requires `data_length' or `data_precision'")
    if defined $self->{'data_scale'}
       && !( defined $self->{'data_length'} || $self->{'data_precision'} );

  bless($self,ref $this || $this);

}



############################################################################
#
#  select()
#
############################################################################

=pod

  $column = SQL::Schema::Table::Column->select($dbh,$table_name,$column_name);

The B<select> method fetches the attributes required by B<new>
from the database and returns the column object. (It calls B<new>
internally.)

If the column could not be found within the database, the method returns undef.

The method's arguments are as follows:

=over

=item C<$dbh>

A database handle as defined by L<DBI(3)>.

=item C<$table_name>

The name of the table without preceeding schema name.

=item C<$column_name>

The name of the column.

=back

=cut

sub select {
  my ($this,$dbh,$table_name,$column_name) = @_;

  croak("Database handle required by select()") unless $dbh;
  croak("Database handle needs to be a reference") unless ref $dbh;
  croak("Table name required by select()") unless $table_name;
  croak("Column name required by select()") unless $column_name;

  my $sth = $dbh->prepare_cached(<<'EOS');
select
    lower(data_type),
    data_length,
    data_precision,
    data_scale,
    nullable,
    data_default
  from
    all_tab_columns
  where
        table_name = upper(?)
    and column_name = upper(?)
EOS
  my $tbl = $dbh->selectall_arrayref($sth,{},$table_name,$column_name);

  return unless @$tbl;

  die "Error: Query returned unexpected number of rows and / or columns."
    unless 1 == @$tbl && 6 == @{$tbl->[0]};

  my %attr = ( 'column_name' => $column_name );
  @attr{qw(data_type data_length data_precision data_scale
           nullable data_default)} = @{$tbl->[0]};

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

  $column_name = $column->name;
  $data_type = $column->data_type;
  $data_length = $column->data_length;
  $data_precision = $column->data_precision;
  $data_scale = $column->data_scale;
  $nullable = $column->nullable;
  $data_default = $column->data_default;

There does exist a speciallity for the C<data_default> method:
If the attribute C<data_default> the method C<data_default>
returns the content of the attribute with eleminated trailing new line.

=cut

sub name           { $_[0]->{'column_name'};    }
sub data_type      { $_[0]->{'data_type'};      }
sub data_length    { $_[0]->{'data_length'};    }
sub data_precision { $_[0]->{'data_precision'}; }
sub data_scale     { $_[0]->{'data_scale'};     }
sub nullable       { $_[0]->{'nullable'};       }
sub data_default   { my $d = $_[0]->{'data_default'} || return; chomp $d; $d; }



############################################################################
#
#  extra attribute methods
#
############################################################################

=pod

The return value of B<nullable> is either C<Y> or C<N>.
This is somewhat uncomfortable for perl programmers.
You might want to use the following method instead:

  $nullable = $sequence->nullable_bool;

It does return C<1> resp. C<0> where its corresponding
attribute method returns C<Y> resp. C<N>.

=cut

my %yesno = qw(N 0  Y 1);
sub nullable_bool { $yesno{$_[0]->nullable}; }



############################################################################
#
#  column_definition()
#
############################################################################

=pod

  $sql = $column->column_definition;
  $sql = "$column";

Returns a string containing the column definition which could be used
as part of an SQL statements for creation of the corresponding column.
This method is overloaded with the string operator. So the two examples
above are equivalent.

=cut

use overload '""' => \&column_definition;

sub column_definition {

  my $self = $_[0];

  my $sql = $self->name . ' ' . $self->data_type;
  if (defined $self->data_length && !defined $self->data_precision) {
    if ($self->data_length) {   # for some data_type data_length is 0
      $sql .= '(' . $self->data_length;
      $sql .= ',' . $self->data_scale if defined $self->data_scale;
      $sql .= ')';
    }
  }
  if (defined $self->data_precision) {
    $sql .= '(' . $self->data_precision;
    $sql .= ',' . $self->data_scale if defined $self->data_scale;
    $sql .= ')';
  }
  $sql .= ' default ' . $self->data_default if $self->data_default;
  $sql .= ' not null' unless $self->nullable_bool;

  return $sql;
}



1;

__END__

=pod

=head1 AUTHOR AND COPYRIGHT

  SQL::Schema::Table::Column is Copyright (C) 2000,
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
L<SQL::Schema::Table(3)>

=cut
