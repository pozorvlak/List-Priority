package List::Priority;

use 5.006;
use strict;
use warnings;
use vars qw($VERSION);

$VERSION = '0.02';


# Constructor. Enables Inheritance
sub new {
	my $this = shift;
	my $class = ref($this) || $this;
	my $self = {};
	bless $self, $class;
	if (@_) {
		my %options = @_;
		$self->{options} = \%options;
	}

	$self->{size} = 0;
	return $self;
}

# Insert an element into the list
# Duplicates are not allowed - might be optional if needed in the future
sub insert {
	# Arguments check
	return 'List::Priority - Expected 3 arguements!' if (scalar(@_) != 3);
	
	# Argument assignment
	my $self = shift;
	my $priority = shift;
	my $object = shift;
	
	# Check that priority is numeric - Thanks Randel/Joseph!
	return 'List::Priority - Priority must be numeric!' 
		if ((~$priority & $priority) ne '0');
	
	# Check that the object isn't already in the list
	if (defined($self->{queues}{$priority})) {
	    foreach (@{$self->{queues}{$priority}}) {
			next if ($_ ne $object);
			return 'List::Priority - Object already on the list';
		}
	}

	# If the list is full
	if (exists($self->{options}{SIZE}) and
		$self->{options}{SIZE} <= $self->{size}) 
	{
		my ($bottom_priority) = (sort {$a <=> $b} keys %{$self->{queues}});
		# And the object's priority is higher then the lowest on on the list 
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
	return 'List::Priority - Pop expected 1 or 2 arguements!' 
		if (scalar(@_) != 1 and scalar(@_) != 2);

	my ($self, $top_priority) = @_;
	return undef if ($self->{size} == 0);
	
	if (defined($top_priority)) {
		return undef unless (defined($self->{queues}{$top_priority}));
	}
	else {
		# Find out the top priority
		($top_priority) = (sort {$b <=> $a} keys %{$self->{queues}});
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
	return 'List::Priority - Unshift expected 1 or 2 arguements!' 
		if (scalar(@_) != 1 and scalar(@_) != 2);

	my ($self, $bottom_priority) = @_;
	return undef if ($self->{size} == 0);
	
	if (defined($bottom_priority)) {
		return undef unless (defined($self->{queues}{$bottom_priority}));
	}
	else {
		# Find out the bottom priority
		($bottom_priority) = (sort {$b <=> $a} keys %{$self->{queues}});
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

1;
__END__
# Documentation

=head1 NAME

List::Priority - Perl extension for a list that manipulates objects by their priority


=head1 SYNOPSIS

  use List::Priority;
  
  # Create an instance
  my $list = List::Priority->new();
  
  # Insert some elements, each woth a unique priority
  $list->insert(2,'World!');
  $list->insert(5,'Hello');
  $list->insert(3,' ');
  
  # Print
  while (my $element = $list->pop()) {
  	  print $element;
  }


=head1 DESCRIPTION

If you want to handle multiple data bits by their order of importance -
This one's for you.

Logic:
Precedence to highest priority object.
If more than one object hold the highest priority - FIFO is king.

Duplicate objects are currently not allowed.

I'd like to thank Joseph N. Hall and Randal L. Schwartz for their
excellent book "Effective Perl Programming" for one of the code hacks...


=head1 METHODS

=over 4


=item B<new> - Constructor

  $p_list = List::Priority->new();
	  
B<new> is the constructor for List::Priority objects

Arguments:

- Accepts an Key-Value list with the list attributes.

  Key: SIZE - The maximum size of the list.
              Inserting after the size is reached will result 
              either in a no-op, or the removal of the most recent 
              lowest priority objects - according to the insert()'s 
              priority.

              Example : $list = List::Priority->new(SIZE => 10);

=item B<insert> - List insertion

  $result = $p_list->insert($priority, $scalar);
	  
Inserts the scalar to the list

Arguments:

 1. Priority must be numeric.
 2. Scalar can be any scalar, including references (objects)

Return value:

1 on success, a string describing the error upon failure

=item B<pop> - List extraction

  $object = $p_list->pop();
	  
Extracts the scalar from the list according to the specified logic.

Arguments:

- Optional - The specific priority value to pop from, 
             instead of the most important one.

             Example : $best_object_p3 = $list->pop(3);

Return value:

The object on success, undef upon failure

=item B<shift> - Reversed list extraction

  $object = $p_list->shift();
	  
Extracts the scalar from the list according to the B<reversed> specified logic (least worthy first).

Arguments:

- Optional 
           - The specific priority value to shift from,
             instead of the least important one.
 
             Example : $worst_object_p3 = $list->shift(3);

Return value:

The object on success, undef upon failure


=head1 EXPORT

None. All interfaces are OO.


=head1 TODO

Well, I'm dangerously neglecting the testing bit...


=head1 AUTHOR

Eyal Udassin, <eyaludassin@hotmail.com>


=head1 SEE ALSO

L<Set::Scalar>.

=cut
