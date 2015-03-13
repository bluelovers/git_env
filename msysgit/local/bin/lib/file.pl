
use File::Basename qw(dirname);

unshift @INC, dirname(__FILE__);

require 'common.pl';

use File::Temp qw/tempfile tempdir/;

sub get_temp_file
{
	my $fh;
	my $file;

	return ($fh, $file) = tempfile('tmpXXXXXX', OPEN => 0);
}

sub parseFile
{
	my $file = shift;
	my $text;

	open (FILE, $file);
	while (<FILE>){
		my $_c = substr $_, 0, 1;
		next if ($_c eq '#');
		$text = $text . rtrim($_) . "\n";
	}
	close(FILE);

	return $text;
}

1;