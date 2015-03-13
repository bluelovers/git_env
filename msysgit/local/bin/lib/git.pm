package Git::Tool;

sub trim_exec($)
{
	my $string = shift;
	$string =~ s/^[\r\n\s]+//;
	$string =~ s/[\r\n\s]+$//;
	return $string;
}

#http://stackoverflow.com/questions/12293944/how-to-find-the-path-of-the-local-git-repository-when-i-am-possibly-in-a-subdire
sub git_root
{
	return trim_exec(`git rev-parse --show-toplevel`);
}

sub git_root_git_dir
{
	return trim_exec(`git rev-parse --git-dir`);
}

sub git_current_path
{
	return trim_exec(`git rev-parse --show-prefix`);
}

sub git_is_inside_work_tree
{
	return trim_exec(`git rev-parse --is-inside-work-tree`);
}

sub git_is_inside_git_dir
{
	return trim_exec(`git rev-parse --is-inside-git-dir`);
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
