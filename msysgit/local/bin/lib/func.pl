
sub println
{
	local $\ = "\n";
	print @_;
}

sub print_r
{
	use Data::Dumper;

	return print Dumper(@_);
}

sub ArrayFunctions
{
	my $a_ref = shift; # reference to
	my @a = @$a_ref; # input array

	my $b_ref = shift; # reference to
	my @b = @$b_ref; # input array

	@Aseen{@a} = (); # lookup table
	@Bseen{@b} = (); # lookup table

	@isec = @diff = @union = @aonly = @bonly = (); # create null

	foreach $e (@a, @b) { $count{$e}++ } # put all

	foreach $e (keys %count) { # interate
		push(@union, $e); # keys of hash

		if ($count{$e} == 2) {
			push @isec, $e; # seen more

		} else {
			push @diff, $e; # seen once =

			push(@aonly, $e) unless exists $Bseen{$e}; # seen once +

			push(@bonly, $e) unless exists $Aseen{$e}; # seen once +
		}
	}
	return (@union, @isec, @diff, @aonly, @bonly); # return
}

sub swrite
{
	my $result = '';
	for (my $i = 0; $i < @_; $i += 2)
	{
		my $format = $_[$i];
		my @args = @{$_[$i+1]};
		if ($format =~ /@[<|>]/)
		{
			$^A = '';
			formline($format, @args);
			$result .= "$^A\n";
		}
		else
		{
			$result .= "$format\n";
		}
	}
	$^A = '';
	return $result;
}

sub swrite2
{
	my $result = '';
	for (my $i = 0; $i < @_; $i += 2)
	{
		my $format = $_[$i];
		my @args = @{$_[$i+1]};
		if ($format =~ /@[<|>]/)
		{
			$^A = '';
			formline($format, @args);
			$result .= "$^A";
		}
		else
		{
			$result .= "$format";
		}
	}
	$^A = '';
	return $result;
}

sub trim_lf($)
{
	my $string = shift;
	$string =~ s/^\n+//;
	$string =~ s/\n+$//;
	$string =~ s/[ \t\r]+\n/\n/g;
	$string =~ s/\n\n\n+/\n\n/g;
	return $string;
}

1;