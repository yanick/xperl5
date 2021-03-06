use strict;
use warnings;

use Test::More;

my @cases = (
    {
        plain    => 's#$%^&plunk',
        expected => 'splunk',
        sub      => 'normalize_plaintext'
    },
    {
        plain    => '1, 2, 3 GO!',
        expected => '123go',
        sub      => 'normalize_plaintext'
    },
    {
        plain    => '1234',
        expected => 2,
        sub      => 'size'
    },
    {
        plain    => '123456789',
        expected => 3,
        sub      => 'size'
    },
    {
        plain    => '123456789abc',
        expected => 4,
        sub      => 'size'
    },
    {
        plain    => 'Never vex thine heart with idle woes',
        expected => [qw(neverv exthin eheart withid lewoes)],
        sub      => 'plaintext_segments'
    },
    {
        plain    => 'ZOMG! ZOMBIES!!!',
        expected => [qw(zomg zomb ies)],
        sub      => 'plaintext_segments'
    },
    {
        plain    => 'Time is an illusion. Lunchtime doubly so.',
        expected => 'tasneyinicdsmiohooelntuillibsuuml',
        sub      => 'ciphertext'
    },
    {
        plain    => 'We all know interspecies romance is weird.',
        expected => 'wneiaweoreneawssciliprerlneoidktcms',
        sub      => 'ciphertext'
    },
    {
        plain    => 'Madness, and then illumination',
        expected => 'msemo aanin dninn dlaet ltshu i',
        sub      => 'normalize_ciphertext'
    },
    {
        plain    => 'Vampires are people too!',
        expected => 'vrela epems etpao oirpo',
        sub      => 'normalize_ciphertext'
    }
);

my $module = $ENV{EXERCISM} ? 'Example' : 'Crypto';
my @subs = qw(new normalize_ciphertext normalize_plaintext plaintext_segments ciphertext size);
plan tests => 2 + @subs + @cases;

ok -e "$module.pm", "Missing $module.pm"
            or BAIL_OUT "You need to create file: $module.pm";

eval "use $module";

ok !$@, "Cannot load $module"
            or BAIL_OUT "Cannot load $module. Does it compile? Does it end with 1;?";

foreach my $sub (@subs) {
    can_ok $module, $sub or BAIL_OUT "Missing package $module; or missing sub $sub()";
}

foreach my $c (@cases) {
    
    my $crypto = $module->new($c->{plain});
    my $sub = $c->{sub};

    if (ref $c->{expected} eq 'ARRAY') {
        is_deeply $crypto->$sub, $c->{expected}, $c->{sub} . " $c->{plain} to @{$c->{expected}}";
    } else {
        is $crypto->$sub, $c->{expected}, $c->{sub} . " $c->{plain} to $c->{expected}";
    }
}
