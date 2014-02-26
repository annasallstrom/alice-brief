#!/usr/bin/perl -w

my $inscript = 0;
while (<>) {
    if (/<script / && !/src=/) {
        $inscript = 1;
    } elsif (/<\/script>/) {
        $inscript = 0;
    } elsif ($inscript) {
        print;
    }
}
