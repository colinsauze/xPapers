package xPapers::Polls::PollOptions;
use xPapers::Conf;
use base qw/xPapers::Object::Cached/;
use Rose::DB::Object::Helpers 'load_speculative','-force';
use strict;

__PACKAGE__->meta->table('poll_opts');
__PACKAGE__->meta->unique_keys(['uId','poId']);
__PACKAGE__->meta->auto_initialize;

1;

package xPapers::Polls::PollOptionsMng;

use base qw(Rose::DB::Object::Manager);

sub object_class { 'xPapers::Polls::PollOptions' }

__PACKAGE__->make_manager_methods('poll_opts');


1;