
use File::Basename qw(dirname);

use constant false			=> 0;
use constant true			=> 1;

use constant LAZYLIBPATH	=> dirname(__FILE__);

unshift @INC, LAZYLIBPATH;

our $false	= false;
our $true	= true;

require 'php.pl';
require 'func.pl';
require 'file.pl';

1;