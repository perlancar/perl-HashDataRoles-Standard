package HashDataRole::Source::Array;

use 5.010001;
use Role::Tiny;
use Role::Tiny::With;

with 'HashDataRole::Spec::Basic';
with 'Role::TinyCommons::Collection::GetItemByPos'; # bonus

# AUTHORITY
# DATE
# DIST
# VERSION

sub new {
    my ($class, %args) = @_;

    my $ary = delete $args{array} or die "Please specify 'array' argument";

    die "Unknown argument(s): ". join(", ", sort keys %args)
        if keys %args;

    # create a hash from an array for quick lookup by key. we also check for
    # duplicates here.
    my $hash = {};
    for my $elem (@$ary) {
        die "Duplicate key '$elem->[0]'" if exists $hash->{$elem->[0]};
        $hash->{$elem->[0]} = $elem;
    }

    bless {
        array => $ary,
        _hash => $hash,
        pos => 0,
    }, $class;
}

sub get_next_item {
    my $self = shift;
    die "StopIteration" unless $self->{pos} < @{ $self->{array} };
    $self->{array}->[ $self->{pos}++ ];
}

sub has_next_item {
    my $self = shift;
    $self->{pos} < @{ $self->{array} };
}

sub reset_iterator {
    my $self = shift;
    $self->{pos} = 0;
}

sub get_iterator_pos {
    my $self = shift;
    $self->{pos};
}

sub get_item_count {
    my $self = shift;
    scalar @{ $self->{array} };
}

sub get_item_at_pos {
    my ($self, $pos) = @_;
    if ($pos < 0) {
        die "Out of range" unless -$pos <= @{ $self->{array} };
    } else {
        die "Out of range" unless $pos < @{ $self->{array} };
    }
    $self->{array}->[ $pos ];
}

sub has_item_at_pos {
    my ($self, $pos) = @_;
    if ($pos < 0) {
        return -$pos <= @{ $self->{array} } ? 1:0;
    } else {
        return $pos < @{ $self->{array} } ? 1:0;
    }
}

sub get_item_at_key {
    my ($self, $key) = @_;
    die "No such key '$key'" unless exists $self->{_hash}{$key};
    $self->{_hash}{$key}[1];
}

sub has_item_at_key {
    my ($self, $key) = @_;
    exists $self->{_hash}{$key};
}

sub get_all_keys {
    my ($self, $key) = @_;
    # to be more deterministic
    sort keys %{$self->{_hash}};
}

1;
# ABSTRACT: Get hash data from a Perl array

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 my $hd = HashData::Array->new(array => [["one","satu"], ["two","dua"], ["three","tiga"]]);


=head1 DESCRIPTION

This role retrieves hash items from a Perl array. Each array element must in
turn be a two-element array.

C<get_next_item()> and C<get_item_at_pos()> will return a pair of C<< [$key,
$value] >>. C<get_item_at_key()> will return just the pair value.

Internally, a hash will be constructed from the array for quick lookup of key.


=head1 ROLES MIXED IN

L<HashDataRole::Spec::Basic>

L<Role::TinyCommons::Collection::GetItemByPos>


=head1 SEE ALSO

L<HashData>

=cut
