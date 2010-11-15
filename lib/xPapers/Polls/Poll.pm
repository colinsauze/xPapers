package xPapers::Polls::Poll;
use base qw/xPapers::Object::Cached/;
use xPapers::Polls::PollOptions;
use strict;

__PACKAGE__->meta->table('polls');
__PACKAGE__->meta->relationships(
      questions => {
        type => 'one to many',
        class=>'xPapers::Polls::Question',
        column_map=> { id => 'poId' },
        methods=>['add_on_save','find','count','get_set_on_save']
      },
      creator => {
        type => 'many to one',
        class=>'xPapers::User',
        column_map=> { owner => 'id' },
      },
      category => {
        type => 'many to one',
        class=>'xPapers::Cat',
        column_map=> { cId => 'id' },
      },


);
__PACKAGE__->meta->auto_initialize;
#print __PACKAGE__->meta->perl_class_definition(indent => 2, braces => 'bsd');
__PACKAGE__->set_my_defaults({
    ordered=>[
        questions=>{field=>'rank'}
    ]
});

sub checkboxes {
    return { randomize => 1};
}

sub registerUser {
    my ($me, $user, $step) = @_;
    $step ||=0;
    # we delete existing reg
    $me->dbh->do("delete from poll_opts where poId=$me->{id} and uId=$user->{id}");
    my $o = xPapers::Polls::PollOptions->new(
        uId=>$user->id,
        poId=>$me->id,
        phd=>$user->phd,
        step=>$step,
        aos=>"|" . join("|", map { $_->name } $user->aos_o ) . "|",
        affils=>"|" . join("|", map { "$_->{discipline} // $_->{role}, " . $_->instName } $user->affils_o) . "|"
    )->save;
}

package xPapers::Polls::PollMng;

use base qw(Rose::DB::Object::Manager);

sub object_class { 'xPapers::Polls::Poll' }

__PACKAGE__->make_manager_methods('polls');


1;
#exit;
#$p->insert_questions;

#my $t = xPapers::Poll->get(1);
#$t->name('test');
#$t->save;

