#!/usr/bin/perl

use Test::More;
BEGIN{
        use_ok('List::Priority');
}

sub capacity_ok {
	my ($list, $capacity, $message) = @_;
	ok($list->size <= $capacity,
		"List doesn't already contain >= $capacity elements");
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

# Tests for altering capacity
my $l = List::Priority->new(capacity => 3);
is($l->capacity, 3, "capacity getter works");
capacity_ok($l, 3, "\$l actually has capacity 3");
$l->capacity(7);
capacity_ok($l, 7, "\$l now has capacity 7");
is($l->size, 7, "\$l contains 7 items");
$l->capacity(5);
capacity_ok($l, 5, "\$l now has capacity 5");
is($l->size, 5, "Items shifted until size <= capacity");

done_testing;
