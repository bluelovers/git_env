package GitTool;

my %map =
(
	'??' => 'Untracked files',

	' M' => 'modified - Changes not staged for commit',
	' R' => 'renamed - Changes not staged for commit',
	' D' => 'deleted - Changes not staged for commit',
	' A' => 'new file - Changes not staged for commit',

	'M ' => 'modified',
	'R ' => 'renamed',
	'D ' => 'deleted',
	'A ' => 'new file',

);

my @map_sort = ('R ', 'M ', 'A ', 'D ', ' R', ' M', ' A', ' D', '??');

sub trim_exec($)
{
	my $string = shift;
	$string =~ s/^[\r\n\s]+//;
	$string =~ s/[\r\n\s]+$//;

	$string =~ s/[ \t\r]+\n/\n/g;

	return $string;
}

sub exec
{
	if ($_[1])
	{
		my @output = `$_[0]`;
		my @ret;

		foreach my $_v (@output)
		{
			push(@ret, trim_exec($_v));
		}

		return @ret;
	}

	return trim_exec(`$_[0]`);
}

sub exec2
{
	return exec("$_[0] 2>\&1", $_[1]);
}

#http://stackoverflow.com/questions/12293944/how-to-find-the-path-of-the-local-git-repository-when-i-am-possibly-in-a-subdire
sub root
{
	return trim_exec(`git rev-parse --show-toplevel`);
}

sub root_git_dir
{
	return trim_exec(`git rev-parse --git-dir`);
}

sub current_path
{
	return trim_exec(`git rev-parse --show-prefix`);
}

sub current_path_full
{
	return git_root().'/'.git_current_path();
}

sub is_inside_work_tree
{
	return trim_exec(`git rev-parse --is-inside-work-tree`);
}

sub is_inside_git_dir
{
	return trim_exec(`git rev-parse --is-inside-git-dir`);
}

sub branch_is_empty
{
	# fatal: ambiguous argument 'HEAD': unknown revision or path not in the working tree.
	my $log_ci = current_commit_id();

	return ($log_ci =~ /fatal/) || 0;
}

sub current_br
{
	return trim_exec(`git rev-parse --abbrev-ref HEAD`);
}

sub current_commit_id
{
	return exec2('git rev-parse HEAD');
}

sub config_path
{
	return root_git_dir().'/config';
}

sub status
{
	my $mode = $_[0];
	my $text;

#	print "\nmode: $mode\n";

	if ($mode > 1)
	{
#		$text = `git commit -m . --dry-run --short`;

		$text = exec("git commit -m . --dry-run --short", 0);
	}
	elsif ($mode < 0)
	{
#		`git add -A`;
#		$text = `git commit -m . --dry-run --short -o .`;
#		`git reset HEAD`;

		exec("git add -A .", 0);
		$text = exec("git commit -m . --dry-run --short -o .", 0);
		exec("git reset HEAD", 0);
	}
	else
	{
#		$text = `git status -s .`;
		$text = exec("git status -s .", 0);
	}
	my @text = split("\n", $text);

	my %list;

#	print $mode;

	foreach (@text)
	{
		my $_k = substr $_, 0, 2;
		my $_v = substr $_, 3;

		my $_k0 = substr $_k, 0, 1;
		my $_k1 = substr $_k, 1, 1;

		if ($mode > 0)
		{
			$do_next = 1;

			if ($_k1 eq ' ')
			{
				$do_next = 0;
			}
		}
		elsif (!$commit_mode && $_k eq '??')
		{
			$do_next = 1;
		}
		else
		{
			$do_next = 0;
		}

#		print "$_k0 ${do_next} $_k1";
#		print "\n";

		next if $do_next;

		push @{$list{$_k}}, $_v;
	}

	if ($mode == 0)
	{
		%list = status_renames_handler(%list);
	}

	return %list;
}

sub status_renames_handler
{
	my %list = @_;
	my @map_skip = ('D', 'A');
	my %list_skip = (
		' D' => (),
		' A' => (),
	);

	my @map_rename;

#	print "\n1.==============\n";
#
#	print log_r(%list);
#
#	print "\n0.==============\n";

	my %list_all = status(-1);

#	print log_r(%list_all);

	foreach my $_m (keys %list_all)
	{
		if ($_m =~ m/R/)
		{
			foreach my $_v (@{$list_all{$_m}})
			{
				my @_s = split('->', $_v);

				$_s[0] = trim_exec($_s[0]);
				$_s[1] = trim_exec($_s[1]);

				push @{$list_skip{' D'}}, $_s[0];
				push @{$list_skip{' A'}}, $_s[1];

				$map_rename{'D'}{$_s[0]} = $_s[1];
				$map_rename{'A'}{$_s[1]} = $_s[0];

				push @{$list_skip{$_m}}, $_v;
			}
		}
	}

#	print "\n9.==============\n";
#
#	foreach my $_m (keys %map_rename)
#	{
#		print "$_m:\n";
#
#		foreach my $_k (keys %{$map_rename{$_m}})
#		{
#			my $_v = $map_rename{$_m}{$_k};
#			print "$_k => $_v\n";
#		}
#	}

#	print "\n2.==============\n";
#
#	print log_r(%list_skip);

	foreach my $_m (keys %list)
	{
#
#		if ($_m =~ m/A/)
#		{
#			my ($union_ref, $isec_ref, $diff_ref, $aonly_ref, $bonly_ref) = ArrayFunctions(\@{$list{$_m}}, \@{$list_skip{' A'}});
#
#			@{$list{$_m}} = @bonly_ref;
#
#			print @union_ref;
#		}
#		elsif ($_m =~ m/D/)
#		{
#			my ($union_ref, $isec_ref, $diff_ref, $aonly_ref, $bonly_ref) = ArrayFunctions(\@{$list{$_m}}, \@{$list_skip{' D'}});
#
#			@{$list{$_m}} = @aonly_ref;
#		}

		if ($_m =~ m/A/)
		{
			my $_k = trim_exec($_m);
			my @temp;

			foreach my $_v (@{$list{$_m}})
			{
				if (exists $map_rename{$_k}{$_v})
				{
					push @{$list_rename{' R'}}, $map_rename{$_k}{$_v} . ' -> ' . $_v;
				}
				else
				{
					push @temp, $_v;
				}
			}

			if ($#temp >= 0)
			{
				@{$list{$_m}} = @temp;
			}
			else
			{
				delete $list{$_m};
			}
		}
		elsif ($_m =~ m/D/)
		{
			my $_k = trim_exec($_m);
			my @temp = ();

			foreach my $_v (@{$list{$_m}})
			{
				if (exists $map_rename{$_k}{$_v})
				{
					push @{$list_rename{' R'}}, $_v . ' -> ' . $map_rename{$_k}{$_v};
				}
				else
				{
					push @temp, $_v;
				}
			}

			if ($#temp >= 0)
			{
				@{$list{$_m}} = @temp;
			}
			else
			{
				delete $list{$_m};
			}
		}
		elsif ($_m =~ m/R/)
		{
			my $_k = trim_exec($_m);
			my @temp;

			foreach my $_v (@{$list{$_m}})
			{
				push @{$list_rename{$_m}}, $_v;
			}

			if ($#temp > 0)
			{
				@{$list{$_m}} = @temp;
			}
			else
			{
				delete $list{$_m};
			}
		}

	}

	return %list;
}

1;

__END__
