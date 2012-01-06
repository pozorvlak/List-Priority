use Test::More;
use List::Priority;

my $l = List::Priority->new();

$l->insert(2,'World!');
$l->insert(5,'Hello');
$l->insert(3,' ');

is_deeply([$l->pop2()], [5, 'Hello'], "pop2 returns (priority, item)");
is_deeply([$l->pop2()], [3, ' '], "pop2 returns (priority, item)");
is_deeply([$l->pop2()], [2, 'World!'], "pop2 returns (priority, item)");

$l->insert(-2,'World!');
$l->insert(-5,'Hello');
$l->insert(-3,' ');

is_deeply([$l->shift2()], [-5, 'Hello'], "shift2 returns (priority, item)");
is_deeply([$l->shift2()], [-3, ' '], "shift2 returns (priority, item)");
is_deeply([$l->shift2()], [-2, 'World!'], "shift2 returns (priority, item)");

done_testing;
