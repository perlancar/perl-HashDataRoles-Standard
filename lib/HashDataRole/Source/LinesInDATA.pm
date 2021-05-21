package HashDataRole::Source::LinesInDATA;

# AUTHORITY
# DATE
# DIST
# VERSION

use Role::Tiny;
use Role::Tiny::With;
with 'HashDataRole::Spec::Basic';

sub new {
    no strict 'refs';

    my $class = shift;

    my $fh = \*{"$class\::DATA"};
    my $fhpos_data_begin = tell $fh;

    bless {
        fh => $fh,
        fhpos_data_begin => $fhpos_data_begin,
        pos => 0, # iterator
    }, $class;
}

sub get_next_item {
    my $self = shift;
    die "StopIteration" if eof($self->{fh});
    $self->{fhpos_cur_item} = tell($self->{fh});
    chomp(my $line = readline($self->{fh}));
    my ($key, $value) = split /:/, $line, 2 or die "Invalid line at position $self->{pos}: no separator ':'";
    $self->{pos}++;
    [$key, $value];
}

sub has_next_item {
    my $self = shift;
    !eof($self->{fh});
}

sub get_iterator_pos {
    my $self = shift;
    $self->{pos};
}

sub reset_iterator {
    my $self = shift;
    seek $self->{fh}, $self->{fhpos_data_begin}, 0;
    $self->{pos} = 0;
}

sub _get_pos_cache {
    no strict 'refs';

    my $self = shift;

    my $class = $self->{orig_class} // ref($self);
    return ${"$class\::_HashData_pos_cache"}
        if defined ${"$class\::_HashData_pos_cache"};

    # build
    my $pos_cache = [];
    $self->reset_iterator;
    while ($self->has_next_item) {
        $self->get_next_item;
        push @$pos_cache, $self->{fhpos_cur_item};
    }
    #use DD; dd $pos_cache;
    ${"$class\::_HashData_pos_cache"} = $pos_cache;
}

sub _get_hash_cache {
    no strict 'refs';

    my $self = shift;

    my $class = $self->{orig_class} // ref($self);
    return ${"$class\::_HashData_hash_cache"}
        if defined ${"$class\::_HashData_hash_cache"};

    my $hash_cache = {};
    $self->reset_iterator;
    while ($self->has_next_item) {
        my $item = $self->get_next_item;
        $hash_cache->{$item->[0]} = $self->{fhpos_cur_item};
    }
    #use DD; dd $hash_cache;
    ${"$class\::_HashData_hash_cache"} = $hash_cache;
}

sub get_item_at_pos {
    my ($self, $pos) = @_;

    my $pos_cache = $self->_get_pos_cache;
    if ($pos < 0) {
        die "Out of range" unless -$pos <= @{ $pos_cache };
    } else {
        die "Out of range" unless $pos < @{ $pos_cache };
    }

    my $oldfhpos = tell $self->{fh};
    seek $self->{fh}, $pos_cache->[$pos], 0;
    chomp(my $line = readline($self->{fh}));
    my ($key, $value) = split /:/, $line, 2;
    seek $self->{fh}, $oldfhpos, 0;
    [$key, $value];
}

sub has_item_at_pos {
    my ($self, $pos) = @_;

    my $pos_cache = $self->_get_pos_cache;
    if ($pos < 0) {
        return -$pos <= @{ $pos_cache } ? 1:0;
    } else {
        return $pos < @{ $pos_cache } ? 1:0;
    }
}

sub get_item_at_key {
    my ($self, $key) = @_;

    my $hash_cache = $self->_get_hash_cache;
    die "No such key '$key'" unless exists $hash_cache->{$key};

    my $oldfhpos = tell $self->{fh};
    seek $self->{fh}, $hash_cache->{$key}, 0;
    chomp(my $line = readline($self->{fh}));
    my (undef, $value) = split /:/, $line, 2;
    seek $self->{fh}, $oldfhpos, 0;
    $value;
}

sub has_item_at_key {
    my ($self, $key) = @_;

    my $hash_cache = $self->_get_hash_cache;
    exists $hash_cache->{$key};
}

sub get_all_keys {
    my ($self, $key) = @_;

    my $hash_cache = $self->_get_hash_cache;
    @$hash_cache;
}


sub fh {
    my $self = shift;
    $self->{fh};
}

sub fh_min_offset {
    my $self = shift;
    $self->{fhpos_data_begin};
}

sub fh_max_offset { undef }

1;
# ABSTRACT: Role to access hash data from DATA section, one line per item

=for Pod::Coverage ^(.+)$

=head1 DESCRIPTION

This role expects lines in the DATA section in the form of:

 <key>:<value>

Internally, a hash cache is built to speed up C<get_item_by_key>. Another array
cache is also built to speed up C<get_item_by_pos>.


=head1 ROLES MIXED IN

L<ArrayDataRole::Spec::Basic>


=head1 PROVIDED METHODS

=head2 fh

Returns the DATA filehandle.

=head2 fh_min_offset

Returns the starting position of DATA.

=head2 fh_max_offset

Returns C<undef>.


=head1 SEE ALSO

Other C<HashDataRole::Source::*>

=cut
