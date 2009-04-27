package FakeApache2;
use strict;
use warnings;

sub use_ServerUtil {
    {
        package Apache2::ServerUtil;
        sub server_root { ; }
        sub restart_count { 0; }
    }
}

package FakeApache2::RequestRec;
use strict;
use warnings;
use HTTP::Request;
use HTTP::Response;
use Class::Accessor;
use base qw(Class::Accessor);

sub new {
    my ($class, $req) = @_;

    if (! $req) {
        $req = HTTP::Request->new;
    }
    my $self = $class->SUPER::new;
    $self->{_request} = $req;
    $self->{_response_content} = '';
    $self->{_response} = HTTP::Response->new(0);
    return $self;
}

sub response {
    my ($self) = @_;

    my $result = $self->{_response};
    $result->content($self->{_response_content});
    return $result;
}

sub print {
    my ($self, $str) = @_;
    $self->{_response_content} .= $str;
}

1;
