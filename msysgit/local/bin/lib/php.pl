
use UNIVERSAL::isa;

# Perl trim function to remove whitespace from the start and end of the string
sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

# Left trim function to remove leading whitespace
sub ltrim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	return $string;
}

# Right trim function to remove trailing whitespace
sub rtrim($)
{
	my $string = shift;
	$string =~ s/\s+$//;
	return $string;
}

sub is_number
{
#	return looks_like_number(shift);

	return defined $_[0] && $_[0] =~ /^[+-]?\d+$/;
}

sub in_array
{
	my ($arr, $search_for) = @_;
	return grep {$search_for eq $_} @$arr;
}

sub is_array
{
	return isa(shift, 'ARRAY');
}

1;