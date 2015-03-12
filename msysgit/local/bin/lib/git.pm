package Git::Tool;

sub trim_exec($)
{
	my $string = shift;
	$string =~ s/^[\r\n\s]+//;
	$string =~ s/[\r\n\s]+$//;
	return $string;
}

sub git_root
{
	return trim_exec(`git rev-parse --show-toplevel`);
}

sub git_branch_is_empty
{
	# fatal: ambiguous argument 'HEAD': unknown revision or path not in the working tree.
	my $log_ci = git_current_commit_id();

	return ($log_ci =~ m/fatal/);
}

sub git_current_br
{
	return trim_exec(`git rev-parse --abbrev-ref HEAD`);
}

sub git_current_commit_id
{
	return trim_exec(`git rev-parse HEAD`);
}

1;

__END__
