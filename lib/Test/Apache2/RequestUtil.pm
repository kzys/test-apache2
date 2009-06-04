package Test::Apache2::RequestUtil;
use strict;
use warnings;

use base qw(Test::Apache2::RequestIO);

__PACKAGE__->mk_accessors(
    qw(location)
);

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

1;
