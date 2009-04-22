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

sub path_info {
    my ($self) = @_;
    $self->{_request}->uri->path;
}

sub header_in {
    my ($self, $key) = @_;
    $self->{_request}->header($key);
}

sub headers_in {
    my ($self) = @_;
    $self->{_request}->headers;
}

sub send_http_header {
    ;
}

sub subprocess_env {
}

sub location {
}

sub status {
    my ($self, $status) = @_;

    my $resp = $self->{_response};
    if ($status) {
        $resp->code($status);
    } else {
        return $resp->code();
    }
}

sub content_type {
    my ($self, $type) = @_;

    $self->header_out('Content-Type' => $type);
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
