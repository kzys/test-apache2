#! /usr/bin/env perl

use strict;
use warnings;
use Module::Build;

Module::Build->new(
    module_name => 'Test::Apache2',
    license     => 'perl',

    requires => {
        'Class::Accessor::Fast' => 0,
        'APR::Table' => 0,
        'APR::Pool' => 0,
    },
    build_requires => {
        'Test::More' => 0,
        'Test::Pod::Coverage' => 0,
    },
    configure_requires => {
        'Module::Build' => 0,
    },

    meta_add => {
        no_index => { package => [ qw(Apache2::ServerUtil) ] }
    },
)->create_build_script;

