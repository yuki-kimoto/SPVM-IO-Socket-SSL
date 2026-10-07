use Test::More;

use strict;
use warnings;
use lib 't/lib';

use Test::SPVM::Sys::Socket::Util;
use SPVM 'TestCase::IO::Socket::SSL';

my $api = SPVM::api();

my $start_memory_blocks_count = $api->get_memory_blocks_count;

# connect deadline test
{
  # Get an available port dynamically
  my $port = Test::SPVM::Sys::Socket::Util::get_available_port;
  ok(SPVM::TestCase::IO::Socket::SSL->connect_deadline($port));
}

# read deadline test
{
  my $port = Test::SPVM::Sys::Socket::Util::get_available_port;
  ok(SPVM::TestCase::IO::Socket::SSL->read_deadline($port));
}

# write deadline test
{
  my $port = Test::SPVM::Sys::Socket::Util::get_available_port;
  ok(SPVM::TestCase::IO::Socket::SSL->write_deadline($port));
}

{
  ok(SPVM::TestCase::IO::Socket::SSL->accept_deadline);
  ok(SPVM::TestCase::IO::Socket::SSL->read_deadline_specific);
  ok(SPVM::TestCase::IO::Socket::SSL->write_deadline_specific);
}

$api->destroy_runtime_permanent_vars;

my $end_memory_blocks_count = $api->get_memory_blocks_count;
is($end_memory_blocks_count, $start_memory_blocks_count);

done_testing;

