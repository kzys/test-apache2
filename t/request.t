use strict;
use warnings;
use Test::More tests => 2;

use_ok 'Test::Apache2::Server';

{
    package Handler;
    use Apache2::Const -compile => qw(OK);

    sub handler {
        my ($self, $req) = @_;

        Test::More::is($req->method, 'GET', 'method');

        $req->content_type('text/plain');
        print "mod_perl 2.0 rocks!\n";
        return Apache2::Const::OK;
    }
}

my $server = Test::Apache2::Server->new;

$server->location('/foo', {
    PerlResponseHandler => 'Handler',
});

my $resp = $server->get('/foo');
