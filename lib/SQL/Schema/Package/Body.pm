#                              -*- Mode: CPerl -*-
#
#  $Source: lib/SQL/Schema/Package/Body.pm $
#  $Id: Body.pm 1.1 Wed, 12 Apr 2000 16:46:14 +0200 todd $
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



package SQL::Schema::Package::Body;

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

SQL::Schema::Package::Body - A package's body stored within the database


=head1 SYNOPSIS

  my $body = SQL::Schema::Package::Body->new(%attr);

  my $sql = $body->create_statement;
  print $sql;

  print "$body";


=head1 DESCRIPTION

C<SQL::Schema::Package::Body> is a class for objects representing a package's
body stored within the database.
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

  $body = SQL::Schema::Package::Body->new(%attr);

The B<new> method instanciates a package body object. The object is
an in memory representation of a (possible) database package body.
The attributes are given as key value pairs by the hash C<%attr>.
Possible keys are:

  key               required?   value description

  name              yes         the name of the package
                                without preceeding schema name

  text              yes         the concatenation of all the text lines
                                forming the packag body's source code

As a package body is basically a piece of source stored within the
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

  $body = SQL::Schema::Package::Body->select($dbh,$name);

The B<select> method fetches the attributes required by B<new>
from the database and returns the package body object. (It calls B<new>
internally.)

If the package body with the name C<$name> could not be found within
the database, the method returns undef.

The method's arguments are as follows:

=over

=item C<$dbh>

A database handle as defined by L<DBI(3)>.

=item C<$name>

The name of the package without preceeding schema name.

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

  $type = $body->type;

The method C<type> always returns the string "C<package body>".
This package inherits all the other methods from SQL::Schema::Source
as a database package body basically is a special kind of source within
the database. For more information, please have a look at
L<SQL::Schema::Source(3)>.

=cut

sub type             { 'package body' };



1;

__END__

=pod

=head1 AUTHOR AND COPYRIGHT

  SQL::Schema::Package::Body is Copyright (C) 2000,
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
