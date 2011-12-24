package List::Priority;

use 5.006;
use strict;
use warnings;
use vars qw($VERSION);
use Carp;
use List::Util qw/min max/;

$VERSION = '0.03';


# Constructor. Enables Inheritance
sub new {
	my $this = shift;
	my $class = ref($this) || $this;
	my $self = {};
	bless $self, $class;
	if (@_) {
		my %options = @_;
		if (!exists $options{capacity} && exists $options{SIZE}) {
			$options{capacity} = $options{SIZE};
		}
		delete $options{SIZE};
		$self->{options} = \%options;
	}
	$self->{size} = 0;
	return $self;
}

# Insert an element into the list
sub insert {
	# Arguments check
	croak 'List::Priority - Expected 3 arguments!' if (scalar(@_) != 3);

	# Argument assignment
	my $self = shift;
	my $priority = shift;
	my $object = shift;

	# Check that priority is numeric - Thanks Randel/Joseph!
	croak 'List::Priority - Priority must be numeric!'
		if ((~$priority & $priority) ne '0');

	# If the list is full
	if (exists($self->{options}{capacity}) and
		$self->{options}{capacity} <= $self->{size})
	{
		my ($bottom_priority) = min(keys %{$self->{queues}});
		# And the object's priority is higher than the lowest on the list
		# - remove the lowest one to insert it
		if ($priority > $bottom_priority) {
			$self->shift($bottom_priority);
		}
		# Else, just return - the list is full.
		else {
			return 'List::Priority - Object denied, list is full';
		}
	}


	# Insert
	push(@{$self->{queues}{$priority}}, $object);
	++$self->{size};
	return 1;
}

sub pop {
	# Arguments check
	croak 'List::Priority - Pop expected 1 or 2 arguments!'
		if (scalar(@_) != 1 and scalar(@_) != 2);

	my ($self, $top_priority) = @_;
	return undef if ($self->{size} == 0);

	if (defined($top_priority)) {
		return undef unless (defined($self->{queues}{$top_priority}));
	}
	else {
		# Find out the top priority
		($top_priority) = max(keys %{$self->{queues}});
		return undef unless (defined ($top_priority));
	}

	# Remove the queue's first element
	my $object = shift (@{$self->{queues}{$top_priority}});

	# If the queue is now empty - delete it
	delete $self->{queues}{$top_priority}
		if (scalar(@{$self->{queues}{$top_priority}}) == 0);

	# Return the object I just shifted out of the queue
	--$self->{size};
	return $object;
}

sub shift {
	# Arguments check
	croak 'List::Priority - shift expected 1 or 2 arguments!'
		if (scalar(@_) != 1 and scalar(@_) != 2);

	my ($self, $bottom_priority) = @_;
	return undef if ($self->{size} == 0);

	if (defined($bottom_priority)) {
		return undef unless (defined($self->{queues}{$bottom_priority}));
	}
	else {
		# Find out the bottom priority
		($bottom_priority) = min(keys %{$self->{queues}});
		return undef unless (defined ($bottom_priority));
	}

	# Remove the queue's last element
	my $object = CORE::pop (@{$self->{queues}{$bottom_priority}});

	# If the queue is now empty - delete it
	delete $self->{queues}{$bottom_priority}
		if (scalar(@{$self->{queues}{$bottom_priority}}) == 0);

	# Return the object I just shifted out of the queue
	--$self->{size};
	return $object;
}

sub size {
	my ($self) = @_;
	return $self->{size};
}

sub capacity {
	my ($self, $new_capacity) = @_;
	if (defined $new_capacity) {
		$self->{options}{capacity} = $new_capacity;
		while ($self->size > $new_capacity) {
			$self->shift;
		}
	}
	return $self->{options}{capacity};
}

1;
__END__
# Documentation

=head1 NAME

List::Priority - Perl extension for a list that manipulates objects by their priority


=head1 SYNOPSIS

  use List::Priority;

  # Create an instance
  my $list = List::Priority->new();

  # Insert some elements, each with a unique priority
  $list->insert(2,'World!');
  $list->insert(5,'Hello');
  $list->insert(3,' ');

  # Print
  print $list->size()			# prints 3
  while (my $element = $list->pop()) {
  	  print $element;
  }


=head1 DESCRIPTION

If you want to handle multiple data items by their order of importance,
this one's for you.

You may retrieve the highest-priority item from the list using C<pop()>, or the
lowest-priority item from the list using C<shift()>. If two items have the same
priority, they are returned in first-in, first-out order. New items are
inserted using C<insert()>.

You can constrain the capacity of the list using the C<capacity> parameter at
construction time. Low-priority items are automatically evicted once the
specified capacity is exceeded. By default the list's capacity is unlimited.

It is currently not allowed to insert the same object (determined by C<eq>)
twice with the same priority.

I'd like to thank Joseph N. Hall and Randal L. Schwartz for their
excellent book "Effective Perl Programming" for one of the code hacks.

=head1 METHODS

=over 4


=item B<new>

  $p_list = List::Priority->new();

B<new> is the constructor for List::Priority objects. It accepts a key-value
list with the list attributes.

=over 

=item * B<capacity>

The maximum size of the list.

Inserting after the size is reached will result
either in a no-op, or the removal of the most recent
lowest priority objects, according to the C<insert()>'s
priority.

  $list = List::Priority->new(capacity => 10);

=item * B<SIZE>

A synonym for C<capacity>, retained for backwards compatibility. If you specify
both a C<SIZE> and a C<capacity> parameter, C<SIZE> will be ignored.

This option is deprecated, and may disappear in a future release.

=back

=item B<insert>

  $result = $p_list->insert($priority, $scalar);

Inserts the scalar to the list.

C<$priority> must be numeric.

C<$scalar> can be any scalar, including references (objects).

Returns 1 on success, and a string describing the error upon failure.

=item B<pop>

  $object = $p_list->pop();

Extracts the highest-priority scalar from the list.
As an optional argument, takes the specific priority value to pop from, instead
of the most important one.

  $best_object_p3 = $list->pop(3);

Returns the object on success, C<undef> upon failure.

=item B<shift>

  $object = $p_list->shift();

Extracts the B<lowest>-priority scalar from the list.

As an optional argument, takes the specific priority value to shift from,
instead of the least important one.

  $worst_object_p3 = $list->shift(3);

Returns the object on success, C<undef> upon failure.

=item B<size>

  $num_elts = $p_list->size();

Takes no arguments. Returns the number of elements in the priority queue.

=item B<capacity>

  my $capacity = $l->capacity();
  $l->capacity($new_capacity);

Get/set the list's capacity. If called with an argument, sets the capacity to
that value, discarding any excess low-priority items. Returns the (new)
capacity.

=back

=head1 EXPORT

None. All interfaces are OO.


=head1 TODO

More tests.


=head1 AUTHOR

Eyal Udassin, <eyaludassin@hotmail.com>

Currently maintained by Miles Gould, <miles@assyrian.org.uk>

Thanks to Maik Hentsche for bugfixes.

=head1 CONTRIBUTING

You can find the Git repository at L<http://github.com/pozorvlak/List-Priority>.

=head1 SEE ALSO

L<Heap::Priority>, L<List::PriorityQueue>, L<Hash::PriorityQueue>,
L<POE::Queue>, L<Timeout::Queue>, L<Data::PrioQ::SkewBinomial>.

=cut
