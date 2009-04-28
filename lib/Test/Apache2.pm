package Test::Apache2;
use strict;
use warnings;

use vars qw($VERSION);
$VERSION = '0.01';

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
__END__

=head1 NAME

Test::Apache2 - Testing mod_perl handler without httpd (1)

=head1 SYNOPSIS

  use Test::More tests => 1;
  use Test::Apache2;
  
  my $server = Test::Apache2::Server->new;
  $server->location('/myapp', {
      PerlResponseHandler => 'MyAppHandler',
  });
  
  my $resp = $server->get('/myapp');
  is($resp->content, 'hello world');

=head1 DESCRIPTION

Test::Apache2 is a test harness of a mod_perl handler.

=head1 AUTHOR

KATO Kazuyoshi E<lt>kzys@8-p.infoE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Apache::Test>, L<Test::Environment>, L<Apache2::ASP>

=cut
