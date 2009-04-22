package t::Util;
use Exporter qw(import);
@EXPORT = qw(server_with_handler);

use Test::Apache2::Server;

sub server_with_handler {
    my ($code_ref) = @_;

    my $server = Test::Apache2::Server->new;
    $server->location('/handler', {
        PerlResponseHandler => 't::Util::Handler'
    });

    $t::Util::Handler::HANDLER = $code_ref;

    return $server;
}

package t::Util::Handler;
our $HANDLER;

sub handler {
    $HANDLER->(@_);
}

1;

