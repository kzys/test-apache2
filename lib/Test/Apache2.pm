package Test::Apache2;
use strict;
use warnings;

use vars qw($VERSION);
$VERSION = '0.01';

use Test::Apache2::Server;

sub import {
    {
        package Apache2::ServerUtil;

        sub server_root {
            '';
        }

        sub restart_count {
            0;
        }
    }
}

1;
