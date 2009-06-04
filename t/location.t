use strict;
use warnings;
use Test::More tests => 2;
use Test::Apache2;
use HTTP::Request;

my $req = HTTP::Request->new(GET => 'http://example.com/bar');

my $request_rec = Test::Apache2::RequestRec->new($req);
is($request_rec->location, '/bar', 'RequestRec');

{
    package Handler;

    sub handler {
        my ($self, $req) = @_;
        Test::More::is($req->location, '/foo', 'Server');
    }
}

my $server = Test::Apache2::Server->new;

$server->location('/foo', {
    PerlResponseHandler => 'Handler',
});

my $resp = $server->get('/foo');
