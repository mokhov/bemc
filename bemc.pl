#!/usr/bin/perl

# first let's find project root folder (it must have "blocks" or "block" folder in it)

sub makepath {return join('/', @_)}

use Cwd 'abs_path';
my @path = split('/',abs_path($0));
pop @path;

my $blocks_path;
my @tmp;

while ($#path >= 0)
{
    @tmp = grep(-d, map(makepath(@path) . "/" . $_, ('blocks', 'block')));

    last if ($#tmp > -1);
    pop @path;
}

$blocks_path = $tmp[0] . '/';

print "path: $blocks_path\n";


# now $blocks_path has path to blocks folder
use Switch;

my $b; my $e; my $m;
my $current_folder;
foreach $arg(@ARGV) {
    if ($arg =~ /^b-\w+/) 
    {
        print "$arg is block\n";
	  
	$b = $arg;
        $e = "";

	$current_folder = $blocks_path . $arg;
    }
    
    elsif ($arg =~ /^_{2}\w+/) 
    {
        print "$arg is element\n";

        $e = $arg;
	$e =~ s/__//;

	$current_folder = $blocks_path . $b . '/' . $e;
    }

    elsif ($arg =~ /^_\w+_\w+/)
    {
        print "$arg is modifier\n";

	$m = $arg;
	my @tmp = $m =~ /(_[^_]+)/;

	$current_folder = $blocks_path . $b . '/' . ($e ? $e . '/': '') . $tmp[0]; 
    }

    else 
    {
        print "$arg is filetype\n";
    }

    # if folder doen't exist - let's do ir
    `mkdir $current_folder` if (!-d $current_folder);
}

