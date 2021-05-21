package ArrayDataRole::Source::DBI;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use Role::Tiny;
use Role::Tiny::With;
with 'ArrayDataRole::Spec::Basic';

sub new {
    my ($class, %args) = @_;

    my $dsn      = delete $args{dsn};
    my $user     = delete $args{user};
    my $password = delete $args{password};
    my $dbh = delete $args{dbh};
    if (defined $dbh) {
    } elsif (defined $dsn) {
        require DBI;
        $dbh = DBI->connect($dsn, $user, $password, {RaiseError=>1});
    }

    my $sth    = delete $args{sth};
    my $sth_bind_params = delete $args{sth_bind_params};
    my $query  = delete $args{query};
    my $table  = delete $args{table};  # XXX quote
    my $column = delete $args{column}; # XXX quote
    if (defined $sth) {
    } else {
        die "You specify 'query' or 'table' & 'column', but you don't specify ".
            "dbh/dsn+user+password, so I cannot create a statement handle"
            unless $dbh;
        if (defined $query) {
        } elsif (defined $table && defined $column) {
            $query = "SELECT $column FROM $table";
        } else {
            die "Please specify 'sth', 'query', or 'table' & 'column' arguments";
        }
        $sth = $dbh->prepare($query);
        $sth->execute(@{ $sth_bind_params // [] }); # to check query syntax
    }

    my $row_count_sth = delete $args{row_count_sth};
    my $row_count_sth_bind_params = delete $args{row_count_sth_bind_params};
    my $row_count_query = delete $args{row_count_query};
    if (defined $row_count_sth) {
    } else {
        die "You specify 'row_count_query' or 'table', but you don't specify ".
            "dbh/dsn+user+password, so I cannot create a statement handle"
            unless $dbh;
        if (defined $row_count_query) {
        } elsif (defined $table) {
            $row_count_query = "SELECT COUNT(*) FROM $table";
        } else {
            die "For getting row count, please specify 'row_count_sth', ".
                "'row_count_query', or 'table' argument";
        }
        $row_count_sth = $dbh->prepare($row_count_query);
        $sth->execute(@{ $row_count_sth_bind_params // [] }); # to check query syntax
    }

    die "Unknown argument(s): ". join(", ", sort keys %args)
        if keys %args;

    bless {
        #dbh => $dbh,
        sth => $sth,
        sth_bind_params => $sth_bind_params,
        row_count_sth => $row_count_sth,
        row_count_sth_bind_params => $row_count_sth_bind_params,
        pos => 0, # iterator pos
        #buf => '', # exists when there is a buffer
    }, $class;
}

sub get_next_item {
    my $self = shift;
    if (exists $self->{buf}) {
        $self->{pos}++;
        return delete $self->{buf};
    } else {
        my $row = $self->{sth}->fetchrow_arrayref;
        die "StopIteration" unless $row;
        $self->{pos}++;
        $row->[0];
    }
}

sub has_next_item {
    my $self = shift;
    if (exists $self->{buf}) {
        return 1;
    }
    my $row = $self->{sth}->fetchrow_arrayref;
    return 0 unless $row;
    $self->{buf} = $row->[0];
    1;
}

sub get_item_count {
    my $self = shift;
    $self->{row_count_sth}->execute(@{ $self->{row_count_sth_bind_params} // [] });
    my ($row_count) = $self->{row_count_sth}->fetchrow_array;
    $row_count;
}

sub reset_iterator {
    my $self = shift;
    $self->{sth}->execute(@{ $self->{sth_bind_params} // [] });
    $self->{pos} = 0;
}

sub get_iterator_pos {
    my $self = shift;
    $self->{pos};
}

sub get_item_at_pos {
    my ($self, $pos) = @_;
    $self->reset_iterator if $self->{pos} > $pos;
    while (1) {
        die "Out of range" unless $self->has_next_item;
        my $item = $self->get_next_item;
        return $item if $self->{pos} > $pos;
    }
}

sub has_item_at_pos {
    my ($self, $pos) = @_;
    return 1 if $self->{pos} > $pos;
    while (1) {
        return 0 unless $self->has_next_item;
        $self->get_next_item;
        return 1 if $self->{pos} > $pos;
    }
}

1;
# ABSTRACT: Role to access elements from DBI

=for Pod::Coverage ^(.+)$

=head1 DESCRIPTION

This role expects array data in L<DBI> database table or query.

Note: C<get_item_at_pos()> and C<has_item_at_pos()> are slow (O(n) in worst
case) because they iterate. Caching might be added in the future to speed this
up.


=head1 METHODS

=head2 new

Usage:

 my $ary = $CLASS->new(%args);

Arguments:

=over

=item * sth

=item * dbh

=item * query

=item * table

=item * column

Either of L</sth>, L</dbh>, L</query>, or L</table> + L</column> is required.

=item * row_count_sth

=item * row_count_query

One of L</row_count_sth>, L</row_count_query>, or L</table> is required. If you
specify C<row_count_query> or C<table>, you need to specify L</dbh> or L</dsn>.

=back


=head1 ROLES MIXED IN

L<ArrayDataRole::Spec::Basic>


=head1 SEE ALSO

L<DBI>

L<ArrayData>

=cut
