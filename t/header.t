use strict;
use warnings;
use Test::More tests => 4;

use_ok 'Test::Apache2::RequestRec';

my $req = Test::Apache2::RequestRec->new;
ok($req->headers_out, 'headers_out');

$req->headers_out->set('X-FooBar' => 'One');
is($req->headers_out->get('X-FooBar'), 'One', 'headers_out set/get');

$req->header_out('X-FooBar' => 'Two');
is($req->headers_out->get('X-FooBar'), 'Two', 'header_out');
