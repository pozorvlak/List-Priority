package List::Priority;

use 5.006;
use strict;
use warnings;
use vars qw($VERSION);

$VERSION = '0.01';

# Constructor. Enables Inheritance
sub new {
	my $this = shift;
	my $class = ref($this) || $this;
	my $self = {};
	bless $self, $class;
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
	
	# Insert
	push(@{$self->{queues}{$priority}}, $object);
	return 1;
}

sub pop {
	# Arguments check
	return 'List::Priority - Expected 1 arguement!' if (scalar(@_) != 1);
	my $self = shift;
	
	# Find out the top priority and remove it's first element
	my ($top_priority) = (sort {$b <=> $a} keys %{$self->{queues}});
	return undef unless (defined ($top_priority));
	my $object = shift (@{$self->{queues}{$top_priority}});
	
	# If the queue is now empty - delete it
	delete $self->{queues}{$top_priority} 
		if (scalar(@{$self->{queues}{$top_priority}}) == 0); 
	
	# Return the object I just shifted out of the queue
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
  $list = List::Priority->new();
  
  # Insert some elements, each woth a unique priority
  $list->insert(2,'World!');
  $list->insert(5,'Hello');
  $list->insert(3,' ');
  
  # Print
  while ($list->pop()) {
  	  print $_;
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

=head1 Methods

=over 4
=item B<new> - Constructor

  $p_list = List::Priority->new();
	  
B<new> is the constructor for List::Priority objects

=item B<insert> - List insertion

  $result = $p_list->insert($priority, $scalar);
	  
Inserts the scalar to the list

Arguments:
- Priority must be numeric.
- Scalar can be any scalar, including references (objects)

Return value:
1 on success, a string describing the error upon failure

=item B<pop> - List extraction

  $object = $p_list->pop();
	  
Extracts the scalar from the list according to the specified logic.

Arguments:
- None.

Return value:
The object on success, undef upon failure


=head2 EXPORT

None. All interfaces are OO.


=head1 AUTHOR

Eyal Udassin, <eyaludassin@hotmail.com>

=head1 SEE ALSO

L<Set::Scalar>.

=cut
