#                              -*- Mode: CPerl -*-
#
#  $Source: lib/SQL/Schema/Source.pm $
#  $Id: Source.pm 1.1 Wed, 12 Apr 2000 14:08:50 +0200 todd $
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



package SQL::Schema::Source;

require 5.005;

use strict;
use vars qw($VERSION);
use Carp;

# $Format: "\$VERSION = $ProjectMajorVersion$.$ProjectMinorVersion$;"$
$VERSION = 0.31;



=pod

=head1 NAME

SQL::Schema::Source - A source stored within the database


=head1 SYNOPSIS

  my $source = SQL::Schema::Source->new(%attr);

  my $sql = $source->create_statement;
  print $sql;

  print "$source";


=head1 DESCRIPTION

C<SQL::Schema::Source> is a class for objects representing the source
of a package, function, procedure etc. stored within the database.
The methods of an instanciated object do allow to access the
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

  $source = SQL::Schema::Source->new(%attr);

The B<new> method instanciates a source object. The object is
an in memory representation of a (possible) database source.
The attributes are given as key value pairs by the hash C<%attr>.
Possible keys are:

  key               required?   value description

  name              yes         the name of the package, procedure,
                                function, ... without preceeding
                                schema name

  type              yes         the type of the source; e.g.
                                  `procedure', `function',
                                  `package', `package body', ...

  text              yes         the concatenation of all the text lines
                                forming the source code

All the keys correspond to the columns with the same name from
Oracle's data dictionary view C<user_sources>. Only C<text> is somewhat
special: It has to be a concatenation of the source lines.

=cut

my @seq_self = qw(name type text);
my $struct_self = {};
for (my $i = 0; $i < @seq_self; $i++) { $struct_self->{$seq_self[$i]} = $i+1;}

sub new {

  my ($this,%attr) = @_;

  for (keys %attr) {
    croak("Unknown attribute `$_'") unless $struct_self->{$_};
  }

  my $self = [ $struct_self, @attr{@seq_self} ];
  for (keys %$self) {
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

  $source = SQL::Schema::Source->select($dbh,$name,$type);

The B<select> method fetches the attributes required by B<new>
from the database and returns the source object. (It calls B<new>
internally.)

If the source with the name C<$name> could not be found within
the database, the method returns undef.

The method's arguments are as follows:

=over

=item C<$dbh>

A database handle as defined by L<DBI(3)>.

=item C<$name>

The name of the source without preceeding schema name.

=item C<$type>

The type of the source.

=back

=cut

sub select {
  my ($this,$dbh,$name,$type) = @_;

  croak("Database handle required as first argument") unless $dbh;
  croak("Database handle needs to be a reference") unless ref $dbh;
  croak("Source name required as second argument") unless $name;
  croak("Source type required as third argument") unless $type;

  my $tbl
    = $dbh->selectall_arrayref($dbh->prepare_cached(<<'EOS'),{},$name,$type);
select
    text
  from
    user_source
  where
       name = upper(?)
   and type = upper(?)
  order by line
EOS
  return unless @$tbl;
  die "Error: Query returned unexpected number of columns."
    unless 1 == @{$tbl->[0]};

  my %attr = ( 'name' => $name, 'type' => $type );
  $attr{'text'} = join('',map {$_->[0]} @$tbl);

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

  $name = $source->name;
  $type = $source->type;
  $text = $source->text;

=cut

sub name             { $_[0]->{'name'}; }
sub type             { $_[0]->{'type'}; }
sub text             { $_[0]->{'text'};  }



############################################################################
#
#  create_statement()
#
############################################################################

=pod

  $sql = $source->create_statement;
  $sql = "$source";

Returns a string containing an SQL statements for creation of this
source. This method is overloaded with the string operator.
So the two examples above are equivalent.

=cut

use overload '""' => \&create_statement;

sub create_statement {

  my $self = $_[0];

  my $sql = 'create ' . $self->text;
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

sub drop_statement { 'drop ' . $_[0]->type . ' ' . $_[0]->name . ";\n"; }



1;

__END__

=pod

=head1 AUTHOR AND COPYRIGHT

  SQL::Schema::Source is Copyright (C) 2000,
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
