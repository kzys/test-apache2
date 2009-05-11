package Test::Apache2::RequestRec;
use strict;
use warnings;
use base qw(Class::Accessor::Fast);

use URI;
use APR::Pool;
use APR::Table;
use Scalar::Util;

__PACKAGE__->mk_accessors(
    qw(status response_body uri location unparsed_uri)
);
__PACKAGE__->mk_ro_accessors(
    qw(headers_in headers_out err_headers_out method)
);

sub new {
    my ($class, @args) = @_;

    if (Scalar::Util::blessed($args[0])) {
        $class->_new_from_request(@args);
    } else {
        $class->_new_from_hash_ref(@args);
    }
}

sub _new_from_hash_ref {
    my ($class, @args) = @_;

    my $self = $class->SUPER::new(@args);
    $self->uri(URI->new($self->uri));

    my $pool = APR::Pool->new;
    map {
        $self->{ $_ } = APR::Table::make($pool, 0);
    } qw(headers_out err_headers_out subprocess_env);

    my $headers_in = APR::Table::make($pool, 0);
    while (my ($key, $value) = each %{ $self->{headers_in} }) {
        $headers_in->set($key => $value);
    }
    $self->{headers_in} = $headers_in;

    return $self;
}

sub _new_from_request {
    my ($class, $req) = @_;

    my %headers_in = map {
        $_ => $req->header($_);
    } $req->header_field_names;

    return $class->new({
        method => $req->method, uri => $req->uri,
        headers_in => \%headers_in
    });
}

sub get_server_port {
    my ($self) = @_;
    $self->uri->port;
}

sub hostname {
    my ($self) = @_;
    $self->uri->host;
}

sub path_info {
    my ($self) = @_;
    $self->path; # really?
}

sub path {
    my ($self) = @_;
    $self->uri->path_query;
}

sub header_in {
    my ($self, $key) = @_;
    return $self->headers_in->get($key);
}

sub header_out {
    my ($self, $key, $value) = @_;
    return $self->headers_out->set($key, $value);
}

sub content_type {
    my ($self, $type) = @_;
    $self->headers_out->set('Content-Type', $type);
}

sub send_http_header {
}

sub subprocess_env {
    my ($self, $key, $value) = @_;

    if ($value) {
        $self->subprocess_env->set($key, $value);
    } elsif ($key) {
        $self->subprocess_env->get($key);
    } else {
        $self->{subprocess_env};
    }
}

sub dir_config {
    my ($self, $key, $value) = @_;

    if (ref $key eq 'HASH') {
        $self->{dir_config} = $key;
    } elsif (defined $value) {
        $self->{dir_config}->{$key} = $value;
    } else {
        my $config = $self->{dir_config};
	if ($config) {
	    return $config->{$key};
	}
    }
}

sub args {
    my ($self) = @_;

    return $self->uri->query;
}

sub set_content_length {
    ;
}

sub to_response {
    my ($self) = @_;
    my $result = HTTP::Response->new;

    $result->header('Content-Type', $self->headers_out->get('Content-Type'));
    $result->code($self->status);
    $result->content($self->response_body);

    return $result;
}

sub print {
    my ($self, $str) = @_;
    $self->{response_body} .= $str;
}

1;

=head1 NAME

Test::Apache2::RequestRec - Fake Apache2::RequestRec

=head1 DESCRIPTION

Apache2::RequestRec don't allow you to create an instance manually,
because the instance created automatically by mod_perl.

So this class provides same interface as Apache2::RequestRec
except a public constructor and some setters.

=head1 SEE ALSO

L<Apache2::RequestRec>

=cut
