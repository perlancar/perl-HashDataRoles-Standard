package ArrayData::DBI;

# AUTHORITY
# DATE
# DIST
# VERSION

use strict;
use warnings;

use Role::Tiny::With;
with 'ArrayDataRole::Source::DBI';

1;
# ABSTRACT: Get array data from DBI

=head1 SYNOPSIS

 use ArrayData::DBI;

 my $ary = ArrayData::DBI->new(
     sth           => $dbh->prepare("SELECT foo FROM mytable"),
     row_count_sth => $dbh->prepare("SELECT COUNT(*) FROM mytable"),
 );

 # or
 my $ary = ArrayData::DBI->new(
     dsn           => "DBI:mysql:database=mydb",
     user          => "...",
     password      => "...",
     table         => "mytable",
     column        => "mycolumn",
 );


=head1 DESCRIPTION

This is an C<ArrayData::> module to get array elements from a L<DBI> query.


=head1 SEE ALSO

L<DBI>

L<ArrayData>
