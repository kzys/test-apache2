use strict;
use warnings;
use Test::More tests => 1;
use Test::Apache2::RequestRec;
use HTTP::Request;

my $req = HTTP::Request->new(GET => 'http://www.example.com/');

my $req_rec = Test::Apache2::RequestRec->new($req);
is($req_rec->uri, '/');
