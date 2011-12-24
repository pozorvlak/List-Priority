#!/usr/bin/perl

use Test::More;
BEGIN{
        use_ok('List::Priority');
}

sub capacity_ok {
	my ($list, $capacity, $message) = @_;
	my $elems_to_insert = 2 * ($capacity - $list->size);
	for my $i (0 .. $elems_to_insert) {
		$list->insert($i, $i);
	}
	is($list->size, $capacity, $message);
}

my $list = List::Priority->new(capacity => 5);

for my $i (0 .. 9) {
	$list->insert($i, $i);
}
is($list->size(), 5, "Size-constrained list doesn't grow beyond capacity");
is($list->pop(), 9, "High-priority items aren't evicted");
is($list->shift(), 5, "Low-priority items are evicted");

# Tests for deprecated SIZE option
capacity_ok(List::Priority->new(SIZE => 17), 17, "SIZE option works");
capacity_ok(List::Priority->new(SIZE => 17, capacity => 9), 9,
	"If SIZE and capacity both given, capacity wins");

done_testing;
