use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME' => 'Test::Apache2',
    'VERSION_FROM' => 'lib/Test/Apache2.pm',
    'PREREQ_PM' => {
        'Test::More' => 0.86,
    },
);
