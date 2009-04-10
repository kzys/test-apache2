package Test::Apache2::Server;
use strict;
use warnings;
use base qw(Class::Accessor::Fast);
__PACKAGE__->mk_accessors(qw(host));

use Test::Apache2::Request;
use HTTP::Response;

sub new {
    my ($class, @args) = @_;

    my $self = $class->SUPER::new(@args);
    $self->{handlers} = [];

    if (! $self->host) {
	$self->host('example.com');
    }

    return $self;
}

sub location {
    my ($self, $path, $handler, $config_ref) = @_;

    unshift @{ $self->{handlers} }, {
        path    => $path,
        handler => $handler,
        config  => $config_ref
    };
}

sub request {
    my ($self, $http_request) = @_;

    my %headers_in = map {
	$_ => $http_request->header($_);
    } $http_request->header_field_names;

    my $req = Test::Apache2::Request->new({
        method => $http_request->method, uri => $http_request->uri,
	headers_in => \%headers_in
    });
    $self->_request($req);
}

sub get {
    my ($self, $path) = @_;

    my $req = Test::Apache2::Request->new({
        method => 'GET', uri => 'http://' . $self->host . $path,
	headers_in => {}
    });
    $self->_request($req);
}

sub _select {
    my ($self, $path) = @_;
    for my $hash_ref (@{ $self->{handlers} }) {
        my $index = index $path, $hash_ref->{path};
        if (defined $index && $index == 0) {
            return  $hash_ref->{handler}, $hash_ref->{config};
        }
    }

    return;
}

sub _request {
    my ($self, $req) = @_;

    my ($class, $config) = $self->_select($req->path);
    $req->dir_config($config);
    my $handler = $class->handler($req);

    my $result = HTTP::Response->new;
    $result->header('Content-Type', $req->content_type);
    $result->code($req->status);
    $result->content($req->response_body);
    return $result;
}

1;
