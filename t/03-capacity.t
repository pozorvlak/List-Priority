#!/usr/bin/perl

use Test::More;
BEGIN{
        use_ok('List::Priority');
}

my $list = List::Priority->new( SIZE => 5 );

for my $i (0 .. 9) {
	$list->insert($i, $i);
}
is($list->size(), 5, "Size-constrained list doesn't grow beyond capacity");
is($list->pop(), 9, "High-priority items aren't evicted");
is($list->shift(), 5, "Low-priority items are evicted");

done_testing;
