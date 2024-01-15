package HashData::Hash;

use strict;
use warnings;

use Role::Tiny::With;
with 'HashDataRole::Source::Hash';

# AUTHORITY
# DATE
# DIST
# VERSION

1;
# ABSTRACT: Get hash data from Perl hash

=head1 SYNOPSIS

 use HashData::Hash;

 my $hd = HashData::Hash->new(
     hash => {one=>"satu", two=>"dua", three=>"tiga"},
 );


=head1 DESCRIPTION

This is an C<HashData::> module to get hash items from a Perl hash. See
L<HashDataRole::Source::Hash> for more details.


=head1 SEE ALSO

L<HashData>
