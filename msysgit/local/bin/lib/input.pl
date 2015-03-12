
sub parseCmdLine
{
	my @cmd_line = @_;
	my $param;
	my $param_last;
	my $param_value;
	my %params;
	my $n = 0;

	my $found_msg = 0;

	$params{'params'} = {
		'--ff' => false,
		'--no-ff' => 2,
	};

	my $is_old = true;

	my @help = qw(--h --help --?);

	foreach my $param (@cmd_line)
	{
		$params{'argv'}[$n] = $param;

		my $is_else = false;

		if ($is_old && $found_msg && !is_number($param))
		{
			$is_old = false;
		}

		if ($param_value && $param =~ /^--\S+$/)
		{
			$param_value = false;
		}

		switch ($param)
		{
			case '--no-ff'
			{
				$params{'params'}{'--ff'} = false;
			}
			case '--ff'
			{
				$params{'params'}{$param} = true;
			}
			case '--msg'
			{
				$param_value = true;
			}
			case (@help)
			{
				$params{'params'}{'--help'} = true;
			}
			else
			{
				my $param_key = $param;

				if ($param_value || (is_number($param) && $param_last =~ /^--\S+$/))
				{
					$param_key = $param_last;

					if ($found_msg)
					{

					}

					$params{'params'}{$param_key} = $param;
				}
				elsif ($found_msg)
				{
					if ($is_old)
					{
						switch ($n)
						{
							case 1
							{
								$param_key = '--log';
							}
							case 2
							{
								$param_key = '--no-ff';
							}
							else
							{

							}
						};
					}

					$params{'params'}{$param_key} = $param;
				}
				else
				{
					$param_key = '--msg';

					$params{'params'}{$param_key} = $param;
					$found_msg = true;
				}

				if ($param_key eq '--msg')
				{
					$found_msg = true;
				}

				$param_value = false;
			}
		};

		$param_last = $param;
		$n++;
	}

#	print_r(%params);

	return %params;
}

1;