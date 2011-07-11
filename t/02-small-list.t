use Test::More;

BEGIN{
        use_ok('List::Priority');
}

my $list = List::Priority->new();

$list->insert(2,'World!');
$list->insert(5,'Hello');
$list->insert(3,' ');

is($list->pop(), 'Hello', 'Most important element');

my $error = $list->insert(2,'World!');
is($error, 'List::Priority - Object already on the list', 'Duplicate element');

for my $count (6..12) {
        $list->insert($count, "element$count");
        $list->insert($count, "second$count");
}

is($list->pop(7), 'element7', 'First element with prio 7');
is($list->shift(), 'World!', 'Least important element');

done_testing;
