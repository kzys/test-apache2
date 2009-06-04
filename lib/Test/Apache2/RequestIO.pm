package Test::Apache2::RequestIO;
use strict;
use warnings;

use base qw(Class::Accessor::Fast);

__PACKAGE__->mk_ro_accessors(qw(content response_body));

sub new {
    my ($class, @args) = @_;

    my $self = $class->SUPER::new(@args);

    $self->{request_body_io} = IO::Scalar->new(\$self->content);
    $self->{response_body_io} = IO::Scalar->new(\$self->{response_body});

    return $self;
}

sub discard_request_body {
    my ($self) = @_;
}

sub print {
    my ($self, @args) = @_;
    return $self->{response_body_io}->print(@args);
}

sub printf {
    my ($self, $format, @args) = @_;
    return $self->print(sprintf($format, @args));
}

sub puts {
    my ($self, @args) = @_;
    return $self->print(@args);
}

sub read {
    my ($self, undef, $len, $offset) = @_;
    $self->{request_body_io}->read($_[1], $len, $offset);
}

sub rflush {
    my ($self) = @_;
    $self->{request_body_io}->flush;
}

sub sendfile {
    my ($self, $path, $len, $offset) = @_;

    open(my $file, '<', $path);
    my $bytes = do {
        local $/;
        <$file>;
    };
    close($file);

    return $self->write($bytes, $len, $offset);
}

sub write {
    my ($self, $bytes, $len, $offset) = @_;
    if (! $len) {
        $len = length $bytes;
    }
    return $self->{response_body_io}->write($bytes, $len, $offset);
}

1;
