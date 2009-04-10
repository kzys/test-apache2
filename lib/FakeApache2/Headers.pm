package FakeApache2::Headers;
use strict;
use warnings;

sub new {
    my ($class, $headers) = @_;

    my $self = bless {}, $class;
    $self->{_headers} = $headers;

    return $self;
}

sub set {
    my ($self, $key, $value) = @_;

    $self->{_headers}->header($key => $value);
}

1;
