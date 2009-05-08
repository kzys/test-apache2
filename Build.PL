use strict;
use warnings;
use Module::Build;

Module::Build->new(
    module_name => 'Test::Apache2',
    license     => 'perl',

    requires => {
        'mod_perl' => 0,
    },
    build_requires => {
        'Test::More' => 0,
        'Test::Pod::Coverage' => 0,
    },
    configure_requires => {
        'Module::Build' => 0,
    },

    meta_add => {
        no_index => { file => [ qw(Test/Apache2/Override.pm) ] }
    },
)->create_build_script;

