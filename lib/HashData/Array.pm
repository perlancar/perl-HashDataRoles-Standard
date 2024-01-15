package HashData::Array;

use strict;
use warnings;

use Role::Tiny::With;
with 'HashDataRole::Source::Array';

# AUTHORITY
# DATE
# DIST
# VERSION

1;
# ABSTRACT: Get hash data from Perl array

=head1 SYNOPSIS

 use HashData::Array;

 my $ary = HashData::Array->new(
     array => [["one","satu"], ["two","dua"], ["three","tiga"]],
 );


=head1 DESCRIPTION

This is an C<HashData::> module to get hash items from a Perl array. Each array
element must in turn be a two-element array C<< [$key, $value] >>. See
L<HashDataRole::Source::Array> for more details.


=head1 SEE ALSO

L<HashData>
