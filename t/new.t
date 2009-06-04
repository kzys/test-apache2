use strict;
use warnings;
use Test::More tests => 1;

use Test::Apache2::RequestRec;

ok(Test::Apache2::RequestRec->new, 'new');
