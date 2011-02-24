#!/usr/bin/perl

# first let's find project root folder (it must have "blocks" or "block" folder in it)

use Cwd 'abs_path';
my @path = split('/',abs_path($0));
pop @path;

while (!-d join('/', @path) . '/blocks' && !-d join('/', @path) . '/block' && $#path >= 0)
{
    print join('/', @path) . "/blocks\n";
    pop @path;
}

print $#path;

sub parseParams
{
}


