#!/usr/bin/perl

# first let's find project root folder (it must have "blocks" or "block" folder in it)

sub makepath {return join('/', @_)}

use Cwd 'abs_path';
my @path = split('/',abs_path($0));
pop @path;

my $blocks_path;

while ($#path >= 0)
{
    my @tmp = grep(-d, map(makepath(@path) . "/" . $_, ('blocks', 'block')));
    print '@tmp' . "\n";
    print "@tmp\n";
    print '@tmp --end' . "\n";

    last if (grep(-d, map(makepath(@path) . "/" . $_, ('blocks', 'block'))));
    #last if !-d ($blocks_path = makepath(@path) . "/blocks") || !-d ($blocks_path = makepath(@path) . "/block");
    pop @path;
}

print $blocks_path;

sub parseParams
{
}


