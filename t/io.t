use strict;
use warnings;
use Test::More tests => 1;

use Test::Apache2::RequestRec;

my $req = Test::Apache2::RequestRec->new({
    content => 'hello'
});

my $s;
$req->read($s, 2);
is($s, 'he');
