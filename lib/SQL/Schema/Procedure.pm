#                              -*- Mode: CPerl -*-
#
#  $Source: lib/SQL/Schema/Procedure.pm $
#  $Id: Procedure.pm 1.3 Wed, 12 Apr 2000 16:46:14 +0200 todd $
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



package SQL::Schema::Procedure;

require 5.005;

use strict;
use vars qw($VERSION @ISA);

use Carp;
use SQL::Schema::Source;

# $Format: "\$VERSION = $ProjectMajorVersion$.$ProjectMinorVersion$;"$
$VERSION = 0.31;

@ISA = qw(SQL::Schema::Source);



=pod

=head1 NAME

SQL::Schema::Procedure - A procedure stored within the database


=head1 SYNOPSIS

  my $procedure = SQL::Schema::Procedure->new(%attr);

  my $sql = $procedure->create_statement;
  print $sql;

  print "$procedure";


=head1 DESCRIPTION

C<SQL::Schema::Procedure> is a class for objects representing a procedure
stored within the database.
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

  $procedure = SQL::Schema::Procedure->new(%attr);

The B<new> method instanciates a procedure object. The object is
an in memory representation of a (possible) database procedure.
The attributes are given as key value pairs by the hash C<%attr>.
Possible keys are:

  key               required?   value description

  name              yes         the name of the procedure
                                without preceeding schema name

  text              yes         the concatenation of all the text lines
                                forming the procedure's source code

As a procedure is basically a piece of source stored within the
database, this class inherits all methods from C<SQL::Schema::Source>.
So please have a look at the new method describet at
L<SQL::Schema::Source(3)>. Though the new method here overwrites
the new method there, it calls the super class's new method
with just the key value pair for the source's C<type> added.

=cut

sub new {
  my $this = shift;
  $this->SUPER::new(@_,('type' => $this->type));
}



############################################################################
#
#  select()
#
############################################################################

=pod

  $procedure = SQL::Schema::Procedure->select($dbh,$name);

The B<select> method fetches the attributes required by B<new>
from the database and returns the procedure object. (It calls B<new>
internally.)

If the procedure with the name C<$name> could not be found within
the database, the method returns undef.

The method's arguments are as follows:

=over

=item C<$dbh>

A database handle as defined by L<DBI(3)>.

=item C<$name>

The name of the procedure without preceeding schema name.

=back

=cut

sub select {
  my $this = shift;
  $this->SUPER::select(@_,$this->type);
}



############################################################################
#
#  attribute methods
#
############################################################################

=pod

=head2 Methods

The following attribute methods do exist:

  $type = $procedure->type;

The method C<type> always returns the string "C<procedure>".
This package inherits all the other methods from SQL::Schema::Source
as a database procedure basically is a special kind of source within
the database. For more information, please have a look at
L<SQL::Schema::Source(3)>.

=cut

sub type             { 'procedure' };



1;

__END__

=pod

=head1 AUTHOR AND COPYRIGHT

  SQL::Schema::Procedure is Copyright (C) 2000,
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
L<SQL::Schema::Source(3)>

=cut
