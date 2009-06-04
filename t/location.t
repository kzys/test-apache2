use strict;
use warnings;

{
    package Handler;
    use Test::More tests => 1;

    sub handler {
        my ($self, $req) = @_;
        is($req->location, '/foo');
    }
}

use Test::Apache2::Server;
my $server = Test::Apache2::Server->new;

$server->location('/foo', {
    PerlResponseHandler => 'Handler',
});

my $resp = $server->get('/foo');
