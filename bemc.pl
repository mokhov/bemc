#!/usr/bin/perl

# first let's find project root folder (it must have "blocks" or "block" folder in it)

sub makepath {return join('/', @_)}

my @path = split('/', `pwd`);
$path[$#path] =~ s/\n//;

use Cwd 'abs_path';
my @tpl_path = split('/',abs_path($0));
pop @tpl_path;
my $tpl_path = join('/',@tpl_path) . "/tpl";

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

my $b; my $e; my @m;
my $current_folder;
my $old_notation = 0;

foreach $arg(@ARGV) {
    if ($arg eq "--old")
    {
       $old_notation = 1;
    }

    # is this a block
    elsif ($arg =~ /^b-\w+/) 
    {
	$b = $arg;
        $e = "";
	$#m = -1;

	$current_folder = $blocks_path . $arg;
    }


    # maybe this is element
    elsif ($arg =~ /^_{2}\w+/) 
    {
        $e = $arg;
	$e =~ s/__//;
	$#m = -1;

	$current_folder = $blocks_path . $b . '/' . $e;
    }


    # hmmm... modifier?
    elsif ($arg =~ /^_\w+_\w+/)
    {
	$tmp = $arg;
	@m = $tmp =~ /_([^_]+)_([^_]+)/;

	$current_folder = $blocks_path . $b . '/' . ($e ? $e . '/': '') . "_" . $m[0]; 
    }


    # if else - than it is filetype
    else 
    {
        # filename base, also CSS selector
	my $filename_base = $b . ($e ? "__$e" : "") . ($#m > 0 ? ($old_notation ? "_$m[1]" : "_$m[0]_$m[1]") : ""); 

        # if we need to delete file, it has - inside
	if ($arg =~ /-\w+/)
	{ 
	   $arg =~ s/^-//;
	   my $ext = $arg =~ /^ie/ ? "$arg.css" : "$arg";
	   `rm -rf  $current_folder/$filename_base.$ext`;
	   print "- $current_folder/$filename_base.$ext\n";
	}

        else 
	{
	    my $filename = $current_folder . "/" . $filename_base;
	    my $replacement;

            # xsl file
	    if ($arg eq "xsl")
	    {
	        open I, "<$tpl_path/xsl.tpl";

	        $filename .= ".xsl";
	        $replacement = "lego:" . $b . ($e ? "/lego:$e" : "") . ($#m > 0 ? "[\@lego:$m[0]='$m[1]']" : "");
	    }

	    # js file
	    elsif ($arg eq "js")
	    {
	        open I, "<$tpl_path/js.tpl";
	        $filename .= ".js";
		$replacement = $filename_base;
	    }

	    # css
	    elsif ($arg eq "css" || $arg =~ /^ie/)
	    {
	        open I, "<$tpl_path/css.tpl";
	        $filename .= ($arg =~ /^ie/ ? ".$arg" : "" ) . ".css";
		$replacement = ($arg eq "ie6" ? "* html " : "") . "." . $filename_base . ($arg eq "ie7" ? "[class]" : "") ;
	    }
	
     	    if (!-e $filename)
	    {
	        open O, ">$filename";
    	        while (<I>)
	        {
	            s/%block%/$replacement/g;
		    print O;
	        }
	        close O;
	        close I;
		print "+ $filename\n";
             }
	     else
	     {
	         print "$filename exists couldn't overwrite\n";
	     }
	}
    }



    # if folder doen't exist - let's do it
    `mkdir $current_folder` if ($current_folder && !-d $current_folder);
}

