use xPapers::DB;
use xPapers::Mail::Message;
use strict;

my $role = $ARGV[0];

if ($role eq 'master') {
    xPapers::DB->exec("delete from test_replication");
    xPapers::DB->exec("insert into test_replication set dummy=1");
} elsif ($role eq 'slave') {
    my $r = xPapers::DB->exec("select * from test_replication");
    report_error() unless $r->fetchrow_hashref;
    my $r2 = xPapers::DB->exec("select * from test_replication where time < date_sub(now(), interval $ARGV[1] hour)");
    report_error() if $r2->fetchrow_hashref;
} else {
    print "usage: check-replication.pl master|slave N.\n";
    print "run periodically both on master and slave(s). will alert admins by email at most N hours after replication has stopped working. obviously you need to run it at least every N/2 hours.\n";
}

sub report_error {
    warn "Found replication error";
    print "Found replication error\n";
    xPapers::Mail::MessageMng->notifyAdmin(
        "CRITICAL ERROR: replication has failed",
        "Your xPapers replication is no longer working. Fix that immediately, or all your backups might be useless. This message has been generated by check-replication.pl."
    );
}