use strict;
use warnings;
use Test::More tests => 5;
use t::FooHandler;

use_ok 'Test::Apache2::Server';

my $server = Test::Apache2::Server->new;
ok($server, 'new');

$server->location('/foo', 't::FooHandler');

my $resp = $server->get('/foo');
isa_ok($resp, 'HTTP::Response');
is(
    $resp->header('Content-Type'),
    'text/plain',
    'Content-Type'
);
is(
    $resp->content,
    'hello world',
    'response body'
);
