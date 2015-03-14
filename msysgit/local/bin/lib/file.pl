
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
	my $retarray = shift;

	my @arr;

	open (FILE, $file);
	while (<FILE>){
		my $_c = substr $_, 0, 1;
		next if ($_c eq '#');
		push (@arr, rtrim($_));
	}
	close(FILE);

	return $retarray ? @arr : join(/\n/, @arr);
}

sub basepath
{
	my $path = shift;
	my $base = shift;

	if (index($path, $base) eq 0)
	{
		substr($path, 0, length($base), '');
	}

	return $path;
}

1;