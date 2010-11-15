package xPapers::Object::Lockable;
use DateTime;

sub lockId {
    my ($me) = @_;
    return $me->meta->class . "::" . $me->id;
}

sub lock {
    my ($me, $userId) = @_;
    return 1 unless $me->{id}; #no id = new = no need for lock
    return 0 unless $userId;
    # if there is a lock already, check if it has expired or same user
    my $lock;
    if ($lock = xPapers::Lock->get($me->lockId)) {
    
        if ($lock->uId == $userId) {
            return 1;
        } else {
            my $dur = DateTime->now->subtract(hours=>1)->subtract_datetime($lock->time);
            return 0 if $dur->is_negative;
        }
    }
    xPapers::Lock->new(
        id=>$me->lockId,
        time=>DateTime->now,
        uId=>$userId
    )->save;
    return 1;
}

sub unlock {
    my ($me,$userId) = @_;
    return 1 unless $me->{id};
    my $lock;
    if ($lock = xPapers::Lock->get($me->lockId) and $lock->uId eq $userId) {
        $lock->delete;
    } else {
#        return 0;
    }
    return 1;
}

1;
