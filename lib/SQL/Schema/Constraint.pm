#                              -*- Mode: CPerl -*-
#
#  $Source: lib/SQL/Schema/Constraint.pm $
#  $Id: Constraint.pm 1.4 Tue, 11 Apr 2000 00:40:37 +0200 the $
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



package SQL::Schema::Constraint;

require 5.005;

use strict;
use vars qw($VERSION);
use Carp;
use SQL::Schema::Table::Column;

# $Format: "\$VERSION = $ProjectMajorVersion$.$ProjectMinorVersion$;"$
$VERSION = 0.31;



=pod

=head1 NAME

SQL::Schema::Constraint - A constraint of a database table


=head1 SYNOPSIS

  my $constraint = SQL::Schema::Constraint->new(%attr);

  my $sql = $constraint->constraint_clause;
  print $sql;

  print "$constraint";


=head1 DESCRIPTION

C<SQL::Schema::Constraint> is a class for objects representing a database
table's constraint. The methods of an instanciated object do allow to access the
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

  $constraint = SQL::Schema::Constraint->new(%attr);

The B<new> method instanciates a constraint object. The object is
an in memory representation of a (possible) database table's constraint.
The attributes are given as key value pairs by the hash C<%attr>.
Possible keys are:

  key                required?   value description

  constraint_name    yes         the constraint's name
  constraint_type    yes         one of
                                   C for check
                                   P for primary key
                                   U for unique key
                                   R for referential integrity
  search_condition   no          text of search condition for
                                 table check
  delete_rule        (*)         either `cascade' or `no action'
                                 default: `no action'
  status             no          either `enabled' or `disabled'
                                 default: `enabled'
  deferrable         no          either `deferrable' or `not deferrable'
                                 default: `not deferrable'
  deferred           no          either `immediate' or `deferred'
                                 default: `immediate'
  generated          no          either `generated name' or `user name'
                                 default: `user name'
  validated          no          either `validated' or `not validated'
                                 default: `validated'

These keys (except columns) and their possible values correspond
exactly to the data dictionary view C<user_constraints> and are
described within Oracle's Server Reference.

Additionally the following keys are possible/required. They do not
relate to columns within the view C<user_constraints>.

  key                required?   value description

  columns            no          a reference to a list with
                                 column objects
  r_schema           (*)         the referenced table's schema
  r_table_name       (*)         the referenced table's name
  r_columns          (*)         a reference to a list containing
                                 column objects representing the
                                 referenced columns

  (*) means: required for referential constrains otherwise not
             allowed

=cut

my @seq_self = qw(constraint_name constraint_type search_condition
                  delete_rule status deferrable deferred generated
                  validated columns
                  r_schema r_table_name r_columns);
my $struct_self = {};
for (my $i = 0; $i < @seq_self; $i++) { $struct_self->{$seq_self[$i]} = $i+1;}
my @seq_defaults = qw(delete_rule status deferrable deferred
                      generated  validated);
my $struct_defaults = {};
for (my $i = 0; $i < @seq_defaults; $i++) {
  $struct_defaults->{$seq_defaults[$i]} = $i+1;
}
my $defaults = [$struct_defaults];
$defaults->{'delete_rule'} = 'no action';
$defaults->{'status'}      = 'enabled';
$defaults->{'deferrable'}  = 'not deferrable';
$defaults->{'deferred'}    = 'immediate';
$defaults->{'generated'}   = 'user name';
$defaults->{'validated'}   = 'validated';

my %enumerates = (
     'constraint_type' => { map {$_=>1} qw(C P U R) },
     'delete_rule'     => { 'cascade'        => 1, 'no action'      => 0 },
     'status'          => { 'enabled'        => 1, 'disabled'       => 0 },
     'deferrable'      => { 'deferrable'     => 1, 'not deferrable' => 0 },
     'deferred'        => { 'deferred'       => 1, 'immediate'      => 0 },
     'generated'       => { 'generated name' => 1, 'user name'      => 0 },
     'validated'       => { 'validated'      => 1, 'not validated'  => 0 },
   );

sub new {

  my ($this,%attr) = @_;

  #
  # check for unknown and missing common required attributes
  #
  for (keys %attr) {
    croak("Unknown attribute `$_'") unless $struct_self->{$_};
  }
  for (qw(constraint_name constraint_type)) {
    croak("Missing required attribute `$_'") unless defined $attr{$_};
  }

  my $self = [ $struct_self, @attr{@seq_self} ];
  undef %attr;

  #
  # normalize and set defaults
  #
  for (grep { $_ ne 'delete_rule' } keys %$defaults) {
    $self->{$_} = lc($self->{$_}||$defaults->{$_});
  }
  $self->{'constraint_type'} = uc $self->{'constraint_type'};
  $self->{'columns'} ||= [];
  $self->{'r_columns'} ||= [];

  #
  # perform further checks on attribute values
  #
  for (qw(columns r_columns)) {
    croak("Attribute `$_' needs to be a list reference")
      if ref $self->{$_} ne 'ARRAY';
  }
  for (grep { $_ ne 'delete_rule' } keys %enumerates) {
    croak("Unsupported value `" . $self->{$_} . "' for attribute `$_'")
      unless defined($enumerates{$_}{$self->{$_}});
  }
  if (    $self->{'constraint_type'} eq 'P'
       || $self->{'constraint_type'} eq 'U'
       || $self->{'constraint_type'} eq 'R' ) {
    croak("Attribute `columns' required for constraint type "
          . $self->{'constraint_type'})
      unless @{$self->{'columns'}};
  }
  if ( $self->{'constraint_type'} eq 'R' ) {
    for (qw(delete_rule)) {
      $self->{$_} = lc($self->{$_}||$defaults->{$_});
    }
    for (qw(delete_rule)) {
      croak("Unsupported value `" . $self->{$_} . "' for attribute `$_'")
        unless defined($enumerates{$_}{$self->{$_}});
    }
    for (qw(delete_rule r_schema r_table_name)) {
      croak("Missing attribute `$_' for referential constraint")
        unless defined $self->{$_};
    }
    croak("Attributes `columns' and `r_columns' need to be lists of same size")
      unless @{$self->{'columns'}} == @{$self->{'r_columns'}};
  } else {
    for (qw(delete_rule r_schema r_table_name)) {
      croak("Attribute `$_' only allowed for referential constraints")
        if defined $self->{$_};
    }
    croak "Attribute `r_columns' only allowed for referential constraints"
      if @{$self->{'r_columns'}};
  }
  if ($self->{'constraint_type'} eq 'C') {
    croak("Attribute `search_condition' required for constraint type "
          . $self->{'constraint_type'})
      unless defined $self->{'search_condition'};
  } else {
    croak("Attribute `search_condition' only allowed for check constraints")
      if defined $self->{'search_condition'};
  }

  bless($self,ref $this || $this);

}



############################################################################
#
#  select_columns()
#
############################################################################

=pod

  @columns = SQL::Schema::Constraint->select_columns($dbh,$schema,$name);

Returns a list of columns in the correct sequence. All the columns
belonging to the constraint with the name C<$schema.$name> are selected
from the database and returned. All the elements of the returned list
are objects of the class C<SQL::Schema::Table::Column>.

The method's arguments are as follows:

=over

=item C<$dbh>

A database handle as defined by L<DBI(3)>.

=item C<$schema>

The name of the constraint's schema.

=item C<$name>

The constraint's name.

=back

=cut

sub select_columns {

  my ($this,$dbh,$schema,$name) = @_;

  croak("Database handle required as first argument") unless $dbh;
  croak("Database handle needs to be a reference") unless ref $dbh;
  croak("Schema name required as second argument") unless $schema;
  croak("Constraint name required as third argument") unless $name;

  my $sth = $dbh->prepare_cached(<<'EOS');
select
    lower(table_name),
    lower(column_name)
  from
    all_cons_columns
  where
        owner = upper(?)
    and constraint_name = upper(?)
  order by
    position
EOS
  my $tbl = $dbh->selectall_arrayref($sth,{},$schema,$name);
  my @columns =  map {SQL::Schema::Table::Column->select($dbh,@$_)} @$tbl;
  die "Did not find a column name for each of the selected columns"
    unless @columns == @$tbl;
  return @columns;
}



############################################################################
#
#  select()
#
############################################################################

=pod

  $constraint = SQL::Schema::Constraint->select($dbh,$constraint_name);

The B<select> method fetches the attributes required by B<new>
from the database and returns the constraint object. (It calls B<new>
internally.)

If the constraint could not be found within the database, the method
returns undef.

The method's arguments are as follows:

=over

=item C<$dbh>

A database handle as defined by L<DBI(3)>.

=item C<$constraint_name>

The name of the constraint.

=back

=cut

sub select {
  my ($this,$dbh,$constraint_name) = @_;

  croak("Database handle required as first argument") unless $dbh;
  croak("Database handle needs to be a reference") unless ref $dbh;
  croak("Constraint name required as second argument") unless $constraint_name;

  my $sth = $dbh->prepare_cached(<<'EOS');
select
    lower(owner) schema,
    constraint_type,
    search_condition,
    lower(r_owner) r_schema,
    r_constraint_name,
    delete_rule,
    status,
    deferrable,
    deferred,
    validated,
    generated
  from
    user_constraints
  where
    constraint_name = upper(?)
EOS
  my $tbl = $dbh->selectall_arrayref($sth,{},$constraint_name);

  return unless @$tbl;

  die "Error: Query returned unexpected number of rows and / or constraints."
    unless 1 == @$tbl && 11 == @{$tbl->[0]};

  my %attr = ( 'constraint_name' => $constraint_name );
  my $schema;
  ($schema,
   @attr{qw(constraint_type search_condition r_schema r_constraint_name
            delete_rule status deferrable deferred validated generated)}
  ) = @{$tbl->[0]};
  my $r_constraint_name = $attr{'r_constraint_name'};
  delete $attr{'r_constraint_name'};

  $attr{'columns'} = [ $this->select_columns($dbh,$schema,$constraint_name) ];
  if (uc $attr{'constraint_type'} eq 'R') {
    my $sth = $dbh->prepare_cached(<<'EOS');
select
    lower(table_name) r_table_name
  from
    user_constraints
  where
        owner = upper(?)
    and constraint_name = upper(?)
EOS
    my $tbl = $dbh->selectall_arrayref(
                      $sth,{},$attr{'r_schema'},$r_constraint_name);
    die 'did not find referenced constraint '
       ."`$attr{'r_schema'}.$r_constraint_name'"
      unless @$tbl;
    die "query did not requrn expected number of rows/columns"
      unless 1 == @$tbl && 1 == @{$tbl->[0]};
    $attr{'r_table_name'} = $tbl->[0]->[0];
    $attr{'r_columns'} = [
      $this->select_columns($dbh,$attr{'r_schema'},$r_constraint_name)
    ];
  }

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

  $constraint_name   = $constraint->name;
  $constraint_type   = $constraint->type;
  $search_condition  = $constraint->search_condition;
  $delete_rule       = $constraint->delet_rule;
  $status            = $constraint->status;
  $deferrable        = $constraint->deferrable;
  $deferred          = $constraint->deferred;
  $generated         = $constraint->generated;
  $validated         = $constraint->validated;
  @columns           = $constraint->columns;
  $r_schema          = $constraint->r_schema;
  $r_table_name      = $constraint->r_table_name;
  @r_columns         = $constraint->r_columns;

=cut

sub name              { $_[0]->{'constraint_name'}; }
sub type              { $_[0]->{'constraint_type'}; }
sub search_condition  { $_[0]->{'search_condition'}; }
sub delete_rule       { $_[0]->{'delete_rule'}; }
sub status            { $_[0]->{'status'}; }
sub deferrable        { $_[0]->{'deferrable'}; }
sub deferred          { $_[0]->{'deferred'}; }
sub generated         { $_[0]->{'generated'}; }
sub validated         { $_[0]->{'validated'}; }
sub columns           { @{$_[0]->{'columns'}}; }
sub r_schema          { $_[0]->{'r_schema'}; }
sub r_table_name      { $_[0]->{'r_table_name'}; }
sub r_columns         { @{$_[0]->{'r_columns'}}; }



############################################################################
#
#  extra attribute methods
#
############################################################################

=pod

The return value of many of the above extra values is text with just
two possible values. Sometimes it is more comfortable for programmers
to have methods returning boolean values. The table below names
extra methods based on the methods above. They return C<1> if the
base method returns the value shown within the 3rd column. Otherwise
the return C<0>.

  extra method     base method    1 if eq          0 if eq

  cascade          delete_rule   cascade          no action
  enabled          status        enabled          disabled
  deferrable_b     deferrable    deferrable       not deferrable
  deferred_b       deferred      deferred         immediate
  generated_b      generated     generated name   user name
  validated_b      validated     validated        not validated

Examples:

  $bool = $constraint->cascade;
  $bool = $constraint->enabled;
  $bool = $constraint->deferrable_b;
  $bool = $constraint->deferred_b;
  $bool = $constraint->generated_b;
  $bool = $constraint->validated_b;

=cut

sub cascade      { defined($_[0]->delete_rule)
                   ?$enumerates{'delete_rule'}->{$_[0]->delete_rule}
                   :return }
sub enabled      { $enumerates{'status'}->{$_[0]->status}; }
sub deferrable_b { $enumerates{'deferrable'}->{$_[0]->deferrable}; }
sub deferred_b   { $enumerates{'deferred'}->{$_[0]->deferred}; }
sub generated_b  { $enumerates{'generated'}->{$_[0]->generated}; }
sub validated_b  { $enumerates{'validated'}->{$_[0]->validated}; }



############################################################################
#
#  constraint_clause()
#
############################################################################

=pod

  $sql = $constraint->constraint_clause;
  $sql = "$constraint";

Returns a string containing the constraint clause which could be used
as part of an SQL statements for creation of the corresponding constraint.
This method is overloaded with the string operator. So the two examples
above are equivalent.

=cut

use overload '""' => \&constraint_clause;

sub constraint_clause {

  my $self = $_[0];

  my $sql = '';

  $sql .= 'constraint ' . $self->name . ' '
    unless $self->generated_b;

  $sql .= ${{
             C=>"check (",
             P=>"primary key (\n",
             U=>"unique (\n",
             R=>"foreign key (\n",
           }}{$self->type};

  if ($self->type eq 'C') {
    $sql .= $self->search_condition . ")";
  } else {
    $sql .= '  ' . join(",\n  ",map {$_->name} $self->columns) . "\n)";
    if ($self->type eq 'R') {
      $sql .= "\nreferences " . $self->r_schema . '.' . $self->r_table_name
           . " (\n  " . join(",\n  ",map {$_->name} $self->r_columns) . "\n)";
    }
    $sql .= "\non delete cascade" if $self->cascade;
  }

  $sql .= "\n" . $self->deferrable . " initially " .  $self->deferred . "\n";
  $sql .= $self->enabled?'enable':'disable';
  if ($self->enabled) {
    $sql .= " " . ($self->validated_b?'validate':'no validate');
  }

  return $sql;
}



1;

__END__

=pod

=head1 AUTHOR AND COPYRIGHT

  SQL::Schema::Constraint is Copyright (C) 2000,
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
L<SQL::Schema::Table(3)>

=cut
