#                              -*- Mode: CPerl -*-
#
#  $Source: lib/SQL/Schema/Trigger.pm $
#  $Id: Trigger.pm 1.1 Wed, 12 Apr 2000 12:46:40 +0200 todd $
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



package SQL::Schema::Trigger;

require 5.005;

use strict;
use vars qw($VERSION);
use Carp;

# $Format: "\$VERSION = $ProjectMajorVersion$.$ProjectMinorVersion$;"$
$VERSION = 0.31;



=pod

=head1 NAME

SQL::Schema::Trigger - A database trigger


=head1 SYNOPSIS

  my $trigger = SQL::Schema::Trigger->new(%attr);

  my $sql = $trigger->create_statement;
  print $sql;

  print "$trigger";


=head1 DESCRIPTION

C<SQL::Schema::Trigger> is a class for objects representing a database
trigger. The methods of an instanciated object do allow to access the
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

  $trigger = SQL::Schema::Trigger->new(%attr);

The B<new> method instanciates a trigger object. The object is
an in memory representation of a (possible) database trigger.
The attributes are given as key value pairs by the hash C<%attr>.
Possible keys are:

  key               required?   value description

  trigger_name      yes         the name of the trigger (without a
                                preceeding schema name)

  description       yes         the "head" of the trigger's create statement
                                excluding `create trigger ' resp.
                                `create or replace trigger ' but including
                                everything from the trigger's name on up to
                                (but not including) the when_clause

  when_clause       no          the when clause of the trigger everything
                                from `when' until the start of the
                                PL/SQL block (remember: the PL/SQL block
                                starts with `declare' or `begin')

  trigger_body      yes         the PL/SQL block of the trigger including
                                `declare', `begin' and `end;'

All the keys correspond to the columns with the same name from
Oracle's data dictionary view C<user_triggers>.

=cut

my @seq_self = qw(trigger_name description when_clause trigger_body);
my $struct_self = {};
for (my $i = 0; $i < @seq_self; $i++) { $struct_self->{$seq_self[$i]} = $i+1;}

sub new {

  my ($this,%attr) = @_;

  for (keys %attr) {
    croak("Unknown attribute `$_'") unless $struct_self->{$_};
  }

  my $self = [ $struct_self, @attr{@seq_self} ];
  for (qw(trigger_name description trigger_body)) {
    croak("Missing required attribute `$_'") unless defined $self->{$_};
  }

  bless($self,ref $this || $this);

}



############################################################################
#
#  select()
#
############################################################################

=pod

  $trigger = SQL::Schema::Trigger->select($dbh,$name);

The B<select> method fetches the attributes required by B<new>
from the database and returns the trigger object. (It calls B<new>
internally.)

If the trigger with the name C<$name> could not be found within
the database, the method returns undef.

The method's arguments are as follows:

=over

=item C<$dbh>

A database handle as defined by L<DBI(3)>.

=item C<$name>

The name of the trigger without preceeding schema name.

=back

=cut

sub select {
  my ($this,$dbh,$name) = @_;

  croak("Database handle required as first argument") unless $dbh;
  croak("Database handle needs to be a reference") unless ref $dbh;
  croak("Trigger name required as second argument") unless $name;

  my $tbl = $dbh->selectall_arrayref($dbh->prepare_cached(<<'EOS'),{},$name);
select
    description,
    when_clause,
    trigger_body
  from
    user_triggers
  where
   trigger_name = upper(?)
EOS
  return unless @$tbl;
  die "Error: Query returned unexpected number of rows and / or columns."
    unless 1 == @$tbl && 3 == @{$tbl->[0]};

  my %attr = ( 'trigger_name' => $name );
  @attr{qw(description when_clause trigger_body)} = @{$tbl->[0]};
  $attr{'when_clause'} ||= '';
  for (qw(when_clause trigger_body)) {
    $attr{$_} =~ s/\0$//;      # Oracle appends an \0
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

  $name = $trigger->name;
  $description = $trigger->description;
  $when_clause = $trigger->when_clause;
  $trigger_body = $trigger->trigger_body;

=cut

sub name             { $_[0]->{'trigger_name'}; }
sub description      { $_[0]->{'description'};  }
sub when_clause      { $_[0]->{'when_clause'};  }
sub trigger_body     { $_[0]->{'trigger_body'}; }



############################################################################
#
#  create_statement()
#
############################################################################

=pod

  $sql = $trigger->create_statement;
  $sql = "$trigger";

Returns a string containing an SQL statements for creation of this
trigger. This method is overloaded with the string operator.
So the two examples above are equivalent.

=cut

use overload '""' => \&create_statement;

sub create_statement {

  my $self = $_[0];

  my $sql = 'create trigger ' . $self->description;
  $sql .= 'when (' . $self->when_clause . ")\n"
    if $self->when_clause;
  $sql .= $self->trigger_body;
  $sql =~ s/\s+$//;
  $sql .= "\n/\n";

  return $sql;
}



############################################################################
#
#  drop_statement()
#
############################################################################

=pod

  $sql = $trigger->drop_statement;

Returns a string containing an SQL statement that would drop this
trigger.

=cut

sub drop_statement { 'drop trigger ' . $_[0]->name . ";\n"; }



1;

__END__

=pod

=head1 AUTHOR AND COPYRIGHT

  SQL::Schema::Trigger is Copyright (C) 2000,
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
