#                              -*- Mode: CPerl -*-
#
#  $Source: lib/SQL/Schema.pm $
#  $Id: Schema.pm 1.14 Tue, 25 Apr 2000 23:22:33 +0200 todd $
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



package SQL::Schema;

require 5.005;

use strict;
use vars qw($VERSION);

use Carp;
use SQL::Schema::Function;
#use SQL::Schema::Index;
use SQL::Schema::Package;
use SQL::Schema::Package::Body;
use SQL::Schema::Procedure;
use SQL::Schema::Sequence;
use SQL::Schema::Table;
use SQL::Schema::Trigger;
use SQL::Schema::View;

# $Format: "\$VERSION = $ProjectMajorVersion$.$ProjectMinorVersion$;"$
$VERSION = 0.31;



=pod

=head1 NAME

SQL::Schema - Convert a data dictionary into SQL statements


=head1 SYNOPSIS

  use DBI;

  my $dbh = DBI->connect(...);

  use SQL::Schema;

  my $schema = SQL::Schema->new($dbh);

  my $sql = $schema->string;
  print $sql;

  print "$schema";


=head1 WARNING

This is alpha software.
It currently works with Oracle databases only.
The name of the module might be changed in future
releases as well as its interface.

If somebody is modifying the datase schema during the life time
of an C<SQL::Schema> object, the object will probably fail and / or
produce wrong information.


=head1 DESCRIPTION

C<SQL::Schema> is a class for objects representing a database schema.
The methods of an instanciated object do allow to access the information
within a database's data dictionary and to represent them as SQL
create statements and the like using the proper SQL dialect.

=cut



############################################################################
#
#  new()
#
############################################################################

=pod

=head2 Constructor

  $schema = SQL::Schema->new($dbh);

The B<new> method instanciates a schema object. The only argument
required is a database handle, which has to offer the same API as
described within L<DBI(3)>.

=cut

sub new {

  my ($this,$dbh) = @_;

  croak("Database handle required for constructor new()")  unless $dbh;
  croak("Database handle needs to be an object reference") unless ref $dbh;

  my $self = [ {} ];                        # Create a pseudo hash with a
  my @attr = qw(dbh name);                  # strictly limited number of keys.
  for (my $i = 0; $i < @attr; $i++) {       # This should avoid pollution
    $self->[0]->{$attr[$i]} = $i+1;         # of $self's key space.
  }
  $self->{'dbh'} = $dbh;                    # Having to set only 'dbh' at the
                                            # beginning means: This class is
                                            # only an extension of DBI!

  return bless($self,ref $this || $this);

}



############################################################################
#
#  string()
#
############################################################################

=pod

=head2 Methods

  $sql = $schema->string;

Returns an SQL string containing several statements at once.
This string contains all the SQL statements to create the database
schema.

This method is overloaded with the string operator. So the following
two lines are equivalent:

  $sql = $schema->string;
  $sql = "$schema";

=cut

use overload '""' => \&string;

sub string {

  my $self = $_[0];

  return join("\n",
           map {"$_"} $self->select_objects('sequence'),
                      $self->select_objects('table'),
                      #$self->select_objects('index'),
                      $self->select_objects('view'),
                      $self->select_objects('procedure'),
                      $self->select_objects('function'),
                      $self->select_objects('package'),
                      $self->select_objects('package','body'),
                      $self->select_objects('trigger'),
         );

}



sub select_objects {
  my ($self,@type) = @_;
  my $dbh = $self->dbh;
  my $class = 'SQL::Schema::' . join('::',map{ ucfirst lc } @type);
  my $type = join(' ',@type);
  return map { $class->select($dbh,@$_) }
         @{$dbh->selectall_arrayref($dbh->prepare_cached(<<'EOS'),{},$type)};
select lower(object_name) from user_objects
  where object_type = upper(?)
  order by 1
EOS
}



sub name {
  return $_[0]->{'name'} if $_[0]->{'name'};
  my $tbl = $_[0]->dbh->selectall_arrayref(<<'EOS');
select lower(user) from dual
EOS
  die "Internal error: query did not return exactly one row with one column"
    unless 1 == @$tbl && 1 == @{$tbl->[0]};
  return $_[0]->{'name'} = $tbl->[0]->[0];
}



sub dbh {
  $_[0]->{'dbh'};
}



1;

__END__

=pod

=head1 AUTHOR AND COPYRIGHT

  SQL::Schema is Copyright (C) 2000, Torsten Hentschel
                                     Windmuehlenweg 47
                                     44141 Dortmund
                                     Germany

                                     Email: todd@bayleys.ping.de

  All rights reserved.

  You may distribute this package under the terms of either the GNU
  General Public License or the Artistic License, as specified in the
  Perl README file.


=head1 SEE ALSO

L<export_schema(1)>,
L<DBI(3)>,
L<SQL::Schema::Procedure(3)>,
L<SQL::Schema::Sequence(3)>,
L<SQL::Schema::Table(3)>,
L<SQL::Schema::Trigger(3)>,
L<SQL::Schema::View(3)>

=cut
