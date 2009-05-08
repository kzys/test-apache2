use strict;
use warnings;
use Module::Build;

Module::Build->new(
    module_name => 'Test::Apache2',
    license     => 'perl',
    requires    => {
        'Test::More' => 0,
        'Test::Pod::Coverage' => 0,
        'perl'       => 0,
    },
    meta_add    => {
        no_index => { package => [ qw(Test::Apache2::Override) ] }
    },
)->create_build_script;

