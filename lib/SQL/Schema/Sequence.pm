#                              -*- Mode: CPerl -*-
#
#  $Source: lib/SQL/Schema/Sequence.pm $
#  $Id: Sequence.pm 1.5 Tue, 11 Apr 2000 00:40:37 +0200 the $
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



package SQL::Schema::Sequence;

require 5.005;

use strict;
use vars qw($VERSION);
use Carp;

# $Format: "\$VERSION = $ProjectMajorVersion$.$ProjectMinorVersion$;"$
$VERSION = 0.31;



=pod

=head1 NAME

SQL::Schema::Sequence - An Oracle sequence


=head1 SYNOPSIS

  my $sequence = SQL::Schema::Sequence->new(%attr);

  my $sql = $sequence->create_statement;
  print $sql;

  print "$sequence";


=head1 DESCRIPTION

C<SQL::Schema::Sequence> is a class for objects representing an Oracle
sequence. The methods of an instanciated object do allow to access the
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

  $sequence = SQL::Schema::Sequence->new(%attr);

The B<new> method instanciates a sequence object. The object is
an in memory representation of a (possible) oracle sequence.
The attributes are given as key value pairs by the hash C<%attr>.
Possible keys are:

  key            required?   value description

  schema_name    no          The name of the schema for

  sequence_name  yes         The name of the sequence (without a
                             preceeding schema name).

  min_value      no          number
  max_value      no          number
  increment_by   yes         number
  cycle_flag     no          either `Y' or `N'; default: `N'
  order_flag     no          either `Y' or `N'; default: `N'
  cache_size     yes         number
  start_with     yes         number

These keys (except C<schema_name> and C<start_with>) and their
possible values correspond exactly to the data dictionary view
C<user_sequences> and are described within Oracle's Server Reference.

The value for C<start_with> is the number the sequence should start
with.

=cut

my @seq_self = qw(schema_name sequence_name min_value
                  max_value increment_by cycle_flag
                  order_flag cache_size start_with);
my $struct_self = {};
for (my $i = 0; $i < @seq_self; $i++) { $struct_self->{$seq_self[$i]} = $i+1;}

sub new {

  my ($this,%attr) = @_;

  for (keys %attr) {
    croak("Unknown attribute `$_'") unless $struct_self->{$_};
  }
  for (qw(sequence_name increment_by cache_size start_with)) {
    croak("Missing required attribute `$_'") unless defined $attr{$_};
  }

  my $self = [ $struct_self, @attr{@seq_self} ];
  for (qw(cycle_flag order_flag)) {
    $self->{$_} ||= 'N';
    $self->{$_} = uc $self->{$_};
    croak("Unsupported value for `$_'") unless $self->{$_} eq 'Y'
                                            || $self->{$_} eq 'N';
  }
  for (qw(min_value max_value increment_by cache_size start_with)) {
    next unless defined $self->{$_};
    croak("Value for `$_' needs to be an integer")
      unless $self->{$_} =~ /^[-+]?\d{1,38}$/;
  }

  bless($self,ref $this || $this);

}



############################################################################
#
#  select()
#
############################################################################

=pod

  $sequence = SQL::Schema::Sequence->select($dbh,$name);
  $sequence = SQL::Schema::Sequence->select($dbh,$name,$schema_name);

The B<select> method fetches the attributes required by B<new>
from the database and returns the sequence object. (It calls B<new>
internally.) It takes the following arguments:

If the sequence with the name C<$name> could not be found within
the database, the method returns undef.

The method's arguments are as follows:

=over

=item C<$dbh>

A database handle as defined by L<DBI(3)>.

=item C<$name>

The name of the sequence without preceeding schema name.

=item C<$schema_name>

Optionally the name of the database schema.

B<Warning:> The method introduces a bug. The value for C<start_with>
required by the B<new> method is selecte as C<last_number + increment_by>.
If the resulting value is outside the inverval given by C<min_value>
and C<max_value> this is not checked. This means: In extreme cases it
might happen, that the statement produced by the B<create_statement>
method can not really be executed on by a database.

=back

=cut

sub select {
  my ($this,$dbh,$sequence_name,$schema_name) = @_;

  croak("Database handle required by select()") unless $dbh;
  croak("Database handle needs to be a reference") unless ref $dbh;
  croak("Sequence name required by select()") unless $sequence_name;

  my $sth = $dbh->prepare_cached(<<'EOS');
select
    min_value,
    max_value,
    increment_by,
    cycle_flag,
    order_flag,
    cache_size,
    last_number + increment_by start_with
  from
    user_sequences
  where
    sequence_name = upper(?)
EOS
  my $tbl = $dbh->selectall_arrayref($sth,{},$sequence_name);

  return unless @$tbl;

  die "Error: Query returned unexpected number of rows and / or columns."
    unless 1 == @$tbl && 7 == @{$tbl->[0]};

  my %attr;
  $attr{'schema_name'} = $schema_name;
  $attr{'sequence_name'} = $sequence_name;
  @attr{qw(min_value max_value increment_by cycle_flag order_flag
           cache_size start_with)} = @{$tbl->[0]};
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

  $schema_name = $sequence->schema_name;
  $name = $sequence->name;
  $min_value = $sequence->min_value;
  $max_value = $sequence->max_value;
  $increment_by = $sequence->increment_by;
  $cycle_flages = $sequence->cycle_flags;
  $order_flags = $sequence->order_flags;
  $cache_size = $sequence->cache_size;
  $start_with = $sequence->start_with;

=cut

sub schema_name  { $_[0]->{'schema_name'};   }
sub name         { $_[0]->{'sequence_name'}; }
sub min_value    { $_[0]->{'min_value'};     }
sub max_value    { $_[0]->{'max_value'};     }
sub increment_by { $_[0]->{'increment_by'};  }
sub cycle_flag   { $_[0]->{'cycle_flag'};    }
sub order_flag   { $_[0]->{'order_flag'};    }
sub cache_size   { $_[0]->{'cache_size'};    }
sub start_with   { $_[0]->{'start_with'};    }



############################################################################
#
#  extra attribute methods
#
############################################################################

=pod

The return value of B<cycle_flag> resp. B<order_flag> is either C<Y> or C<N>.
This is somewhat uncomfortable for perl programmers. You might want to use
the following two methods instead:

  $cycle_flag = $sequence->cycle;
  $order_flag = $sequence->order;

They do return C<1> resp. C<0> where their corresponding attribute method
returns C<Y> resp. C<N>.

=cut

my %yesno = qw(N 0  Y 1);
sub cycle        { $yesno{$_[0]->cycle_flag}; }
sub order        { $yesno{$_[0]->order_flag}; }



############################################################################
#
#  qualified_name()
#
############################################################################

=pod

  my $qname = $sequence->qualified_name;

Returns the qualified name of the sequence which is the concatenation
of C<schema_name> and C<sequence_name> with a in between if C<schema_name>
has been set. Otherwise only C<sequence_name> is returned.

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

  $sql = $sequence->create_statement;
  $sql = "$sequence";

Returns a string containing an SQL statements for creation of a
sequence. This method is overloaded with the string operator.
So the two examples above are equivalent.

=cut

use overload '""' => \&create_statement;

sub create_statement {

  my $self = $_[0];

  my $sql = 'create sequence ' . $self->qualified_name . "\n";
  $sql .= "  minvalue " . $self->min_value . "\n" if defined $self->min_value;
  $sql .= "  maxvalue " . $self->max_value . "\n" if defined $self->max_value;
  $sql .= "  increment by " . $self->increment_by . "\n";
  $sql .= "  " . (qw(nocycle cycle))[$self->cycle] . "\n";
  $sql .= "  " . (qw(noorder order))[$self->order] . "\n";
  if ( $self->cache_size ) {
    $sql .= "  cache " . $self->cache_size . "\n";
  } else {
    $sql .= "  nocache\n";
  }
  $sql .= "  start with " . $self->start_with . ";\n";

  return $sql;
}



############################################################################
#
#  drop_statement()
#
############################################################################

=pod

  $sql = $sequence->drop_statement;

Returns a string containing an SQL statement that would drop this
sequence.

=cut

sub drop_statement { 'drop sequence ' . $_[0]->qualified_name . ";\n"; }



1;

__END__

=pod

=head1 BUGS

The B<select> method introduces a bug. This occurs if the value
selected from the database for C<start_with> is not valid. For
more information see warning at B<select>.

=head1 AUTHOR AND COPYRIGHT

  SQL::Schema::Sequence is Copyright (C) 2000,
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
L<SQL::Schema(3)>

=cut
