#                              -*- Mode: CPerl -*-
#
#  $Source: Makefile.PL $
#  $Id: Makefile.PL 1.6 Tue, 25 Apr 2000 23:27:34 +0200 todd $
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

require 5.005;

use strict;

use ExtUtils::MakeMaker;

WriteMakefile (
  'NAME'	=> 'SQL::Schema',
  'MAKEFILE'    => 'Makefile',
  # $Format: "  'VERSION'	=> '$ProjectMajorVersion$.$ProjectMinorVersion$',"$
  'VERSION'	=> '0.31',
  'EXE_FILES'   => [ <scripts/*> ],
  'PREREQ_PM'	=> {
                     'DBI'	  => 1.13,
                   },
  'test'	=> {TESTS => 't/[0-9][0-9]-*/[0-9][0-9]*.t'},
);



package MY;

use strict;

sub libscan {
  my ($self, $path) = @_;
  return if $path =~ /\~$/;
  return if $path =~ /\.swp$/;
  return if $path =~ m:/obsolete/:;
  $path;
}

sub postamble {
  <<'EOAMBLE';

pm_to_blib:	README

README:	lib/SQL/Schema.pm
	pod2text lib/SQL/Schema.pm >README

EOAMBLE
}
