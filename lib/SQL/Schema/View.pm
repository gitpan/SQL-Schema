#                              -*- Mode: CPerl -*-
#
#  $Source: lib/SQL/Schema/View.pm $
#  $Id: View.pm 1.2 Wed, 12 Apr 2000 12:46:40 +0200 todd $
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



package SQL::Schema::View;

require 5.005;

use strict;
use vars qw($VERSION);
use Carp;

# $Format: "\$VERSION = $ProjectMajorVersion$.$ProjectMinorVersion$;"$
$VERSION = 0.31;



=pod

=head1 NAME

SQL::Schema::View - A database view


=head1 SYNOPSIS

  my $view = SQL::Schema::View->new(%attr);

  my $sql = $view->create_statement;
  print $sql;

  print "$view";


=head1 DESCRIPTION

C<SQL::Schema::View> is a class for objects representing a database
view. The methods of an instanciated object do allow to access the
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

  $view = SQL::Schema::View->new(%attr);

The B<new> method instanciates a view object. The object is
an in memory representation of a (possible) database view.
The attributes are given as key value pairs by the hash C<%attr>.
Possible keys are:

  key              required?   value description

  view_name        yes         the name of the view (without a
                               preceeding schema name)

  aliases          no          a reference to a list of names
                               for the columns returned by the view

  subquery         yes         the SQL text of the subquery

  constraint_name  no          the name of the constraint for the
                               "with check option"; WARNING: The
                               subquery has to end with the text
                               'with check option ' to make this work
                               correctly

=cut

my @seq_self = qw(view_name aliases subquery constraint_name);
my $struct_self = {};
for (my $i = 0; $i < @seq_self; $i++) { $struct_self->{$seq_self[$i]} = $i+1;}

sub new {

  my ($this,%attr) = @_;

  for (keys %attr) {
    croak("Unknown attribute `$_'") unless $struct_self->{$_};
  }

  my $self = [ $struct_self, @attr{@seq_self} ];
  for (qw(view_name subquery)) {
    croak("Missing required attribute `$_'") unless defined $self->{$_};
  }
  $self->{'aliases'} ||= [];
  for (qw(aliases)) {
    croak("Attribute `$_' needs to be a list reference")
      unless 'ARRAY' eq ref $self->{$_};
  }

  bless($self,ref $this || $this);

}



############################################################################
#
#  select()
#
############################################################################

=pod

  $view = SQL::Schema::View->select($dbh,$name);

The B<select> method fetches the attributes required by B<new>
from the database and returns the view object. (It calls B<new>
internally.)

If the view with the name C<$name> could not be found within
the database, the method returns undef.

The method's arguments are as follows:

=over

=item C<$dbh>

A database handle as defined by L<DBI(3)>.

=item C<$name>

The name of the view without preceeding schema name.

=back

=cut

sub select {
  my ($this,$dbh,$name) = @_;

  croak("Database handle required as first argument") unless $dbh;
  croak("Database handle needs to be a reference") unless ref $dbh;
  croak("View name required as second argument") unless $name;

  my $tbl = $dbh->selectall_arrayref($dbh->prepare_cached(<<'EOS'),{},$name);
select text from user_views where view_name = upper(?)
EOS
  return unless @$tbl;
  die "Error: Query returned unexpected number of rows and / or columns."
    unless 1 == @$tbl && 1 == @{$tbl->[0]};

  my %attr = ( 'subquery' => $tbl->[0]->[0] );

  $attr{'aliases'} =
    [ map { $_->[0] }
    @{$dbh->selectall_arrayref($dbh->prepare_cached(<<'EOS'),{},$name)} ];
select lower(column_name) from user_tab_columns where table_name = upper(?)
  order by column_id
EOS

  $tbl = $dbh->selectall_arrayref($dbh->prepare_cached(<<'EOS'),{},$name);
select lower(constraint_name), generated from user_constraints
  where table_name = upper(?)
EOS

  die "Error: Query returned unexpected number of rows and / or columns."
    unless 0 == @$tbl || ( 1 == @$tbl && 2 == @{$tbl->[0]} );

  $attr{'constraint_name'} = $tbl->[0]->[0]
    if @$tbl && $tbl->[0]->[1] ne 'GENERATED NAME';

  $attr{'view_name'} = $name;

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

  $name = $view->name;
  @aliases = $view->alisaes;
  $subquery = $view->subquery;
  $constraint_name = $view->constraint_name;

=cut

sub name             { $_[0]->{'view_name'};       }
sub aliases          { @{$_[0]->{'aliases'}};      }
sub subquery         { $_[0]->{'subquery'};        }
sub constraint_name  { $_[0]->{'constraint_name'}; }



############################################################################
#
#  create_statement()
#
############################################################################

=pod

  $sql = $view->create_statement;
  $sql = "$view";

Returns a string containing an SQL statements for creation of this
view. This method is overloaded with the string operator.
So the two examples above are equivalent.

=cut

use overload '""' => \&create_statement;

sub create_statement {

  my $self = $_[0];

  my $sql = 'create view ' . $self->name;
  $sql .= ' ( ' .  join(', ', $self->aliases) . ' )' if $self->aliases;
  $sql .= "\n  as " . $self->subquery;
  $sql .= "  constraint " . $self->constraint_name if $self->constraint_name;
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

  $sql = $view->drop_statement;

Returns a string containing an SQL statement that would drop this
view.

=cut

sub drop_statement { 'drop view ' . $_[0]->name . ";\n"; }



1;

__END__

=pod

=head1 AUTHOR AND COPYRIGHT

  SQL::Schema::View is Copyright (C) 2000,
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

=cut
