use Test::More;
use List::Priority;

my $l = List::Priority->new();

$l->insert(2,'World!');
$l->insert(5,'Hello');
$l->insert(3,' ');

is_deeply([$l->pop()], [5, 'Hello'],
	"pop in list context returns (priority, item)");
is_deeply([$l->pop()], [3, ' '],
	"pop in list context returns (priority, item)");
is_deeply([$l->pop()], [2, 'World!'],
	"pop in list context returns (priority, item)");

$l->insert(-2,'World!');
$l->insert(-5,'Hello');
$l->insert(-3,' ');

is_deeply([$l->shift()], [-5, 'Hello'],
	"shift in list context returns (priority, item)");
is_deeply([$l->shift()], [-3, ' '],
	"shift in list context returns (priority, item)");
is_deeply([$l->shift()], [-2, 'World!'],
	"shift in list context returns (priority, item)");

done_testing;
