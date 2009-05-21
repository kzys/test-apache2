use strict;
use warnings;
use Test::More tests => 2;
use Test::Apache2::RequestRec;
use HTTP::Request;

my $req = HTTP::Request->new(GET => 'http://www.example.com/foo?bar=baz');

my $req_rec = Test::Apache2::RequestRec->new($req);
is($req_rec->uri, '/foo');
is($req_rec->unparsed_uri, '/foo?bar=baz');
