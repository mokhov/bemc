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


# now $blocks_path has path to blocks folder

my $b; my $e; my $m;
my $current_folder;
foreach $arg(@ARGV) {

    # is this a block
    if ($arg =~ /^b-\w+/) 
    {
	$b = $arg;
        $e = "";

	$current_folder = $blocks_path . $arg;
    }


    # maybe this is element
    elsif ($arg =~ /^_{2}\w+/) 
    {
        $e = $arg;
	$e =~ s/__//;

	$current_folder = $blocks_path . $b . '/' . $e;
    }


    # hmmm... modifier?
    elsif ($arg =~ /^_\w+_\w+/)
    {
	$m = $arg;
	my @tmp = $m =~ /(_[^_]+)/;

	$current_folder = $blocks_path . $b . '/' . ($e ? $e . '/': '') . $tmp[0]; 
    }


    # if else - than it is filetype
    else 
    {
        print "$arg is filetype\n";
    }



    # if folder doen't exist - let's do it
    `mkdir $current_folder` if (!-d $current_folder);
}

