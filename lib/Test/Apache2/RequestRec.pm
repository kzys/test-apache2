package Test::Apache2::RequestRec;
use strict;
use warnings;
use base qw(Class::Accessor::Fast);

use URI;
use APR::Pool;
use APR::Table;

__PACKAGE__->mk_accessors(
    qw(path_info status response_body uri content_type location unparsed_uri headers_in)
);
__PACKAGE__->mk_ro_accessors(
    qw(headers_out err_headers_out method)
);

sub new {
    my ($class, @args) = @_;

    my $self = $class->SUPER::new(@args);
    $self->uri(URI->new($self->uri));

    my $pool = APR::Pool->new;
    $self->{headers_out} = APR::Table::make($pool, 0);
    $self->{err_headers_out} = APR::Table::make($pool, 0);

    return $self;
}

sub get_server_port {
    my ($self) = @_;
    $self->uri->port;
}

sub hostname {
    my ($self) = @_;
    $self->uri->host;
}

sub path {
    my ($self) = @_;
    $self->uri->path_query;
}

sub header_in {
    my ($self, $key) = @_;
    return $self->headers_in->{ $key };
}

sub header_out {
    my ($self, $key, $value) = @_;
    return $self->headers_out->set($key, $value);
}

sub send_http_header {
}

sub subprocess_env {
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

sub print {
    my ($self, $str) = @_;
    $self->{response_body} .= $str;
}

1;
