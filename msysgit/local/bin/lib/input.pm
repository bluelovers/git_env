package CmdLineTool;

use File::Basename qw(dirname);

unshift @INC, dirname(__FILE__);

use Switch;

require 'common.pl';

my %default;
my %proto;
my @help = qw(--help --h --?);
my $callback;

sub new
{
	my $this = shift;
	my $class = ref($this) || $this;
	my $self = {};

	bless $self, $class;

	$self->_initialize();

	return $self;
}

sub _initialize
{
	my $self = shift;

	our %default;
	our %prototype;
	our @help;

	@{$self->{help}} = @help;

	%{$self->{proto}} = %proto;

	%{$self->{default}} = %default;
}

sub newInstance
{
	return __PACKAGE__->new();
}

sub parse
{
	my $self = shift;
	my @cmd_line = @_;

	$self->parseCmdLine(@cmd_line);

	$self->fixCmdLineParam(\&{$self->{callback}});

	return $self;
}

sub getParam
{
	my $self = shift;
	my $param_key = shift;

	return $self->{params}{$param_key};
}

sub setParam
{
	my $self = shift;
	my $param_key = shift;
	my $param = shift;

	$self->{params}{$param_key} = $param;

	$self->fixCmdLineParam(\&{$self->{callback}});

	return $self;
}

sub fixCmdLineParam
{
	my $self = shift;
	my $callback = shift;

	if ($callback)
	{
		$callback->($self, $self->{params});
	}

	return $self;
}

sub is_key
{
	my $val = defined $_[1] && $_[1] =~ /^--\S+$/ || 0;

#	main::print_r($_[1], $val);

	return $val;
}

sub parseCmdLine
{
	my $self = shift;

	my @cmd_line = @_;
	my $param;
	my $param_last;
	my $param_value;
	my %params;
	my $n = 0;

	if ($self->{default})
	{
		$params{'params'} = $self->{default}
	}

	my $is_old = main::true;

	foreach my $param (@cmd_line)
	{
		my $param_key = $param;
		my $is_key = $self->is_key($param);

		$params{'argv'}[$n] = $param;

		if ($param_value && $is_key)
		{
			$param_value = main::false;
		}

		switch ($param)
		{
			case (@{$self->{help}})
			{
				$param_key = $self->{help}[0];

				$params{'params'}{$param_key} = main::true;

				$param_value = main::false;
			}
			case (%{$self->{proto}})
			{
				$param_value = main::true;
			}
			else
			{
				if ($param_value || $self->is_key($param_last) && !$is_key)
				{
					$param_key = $param_last;
				}

				$params{'params'}{$param_key} = $param;

				$param_value = main::false;
			}
		};

		if ($param_key && !$params{'first'})
		{
			$params{'first'} = $param_key;
		}

		$param_last = $param;
		$n++;
	}

	return %{$self->{params}} = %params;
}

1;