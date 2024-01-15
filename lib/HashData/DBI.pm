package HashData::DBI;

use strict;
use warnings;

use Role::Tiny::With;
with 'HashDataRole::Source::DBI';

# AUTHORITY
# DATE
# DIST
# VERSION

1;
# ABSTRACT: Get hash data from DBI

=head1 SYNOPSIS

 use HashData::DBI;

 my $ary = HashData::DBI->new(
     iterate_sth    => $dbh->prepare("SELECT mykey,myval FROM mytable"),
     get_by_key_sth => $dbh->prepare("SELECT myval FROM mytable WHERE mykey=?"),
     row_count_sth  => $dbh->prepare("SELECT COUNT(*) FROM mytable"),
 );

 # or
 my $ary = HashData::DBI->new(
     dsn           => "DBI:mysql:database=mydb",
     user          => "...",
     password      => "...",
     table         => "mytable",
     key_column    => "mykey",
     val_column    => "myval",
 );


=head1 DESCRIPTION

This is an C<HashData::> module to get array elements from a L<DBI> query.


=head1 SEE ALSO

L<DBI>

L<ArrayData>
