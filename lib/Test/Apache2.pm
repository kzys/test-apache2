package Test::Apache2;
use strict;
use warnings;

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
