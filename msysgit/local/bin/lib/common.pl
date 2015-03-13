
use File::Basename qw(dirname);

use constant false => 0;
use constant true  => 1;

use constant LAZYLIBPATH  => dirname(__FILE__);

unshift @INC, LAZYLIBPATH;

require 'php.pl';
require 'func.pl';

1;