package xPapers::Link::Free;
use strict;

sub new {
 	my $class = shift;
 	my $self = { @_ };
	bless $self, $class;
	return $self;
}

sub site { shift->{site} }

sub init {
    my $me = shift;
    my %p = @_;
    $me->{site} = $p{site};
    $me->{re} = file2array($me->site->fullConfFile( 'nonfree.txt' ) );
    $me->{bad} = file2array($me->site->fullConfFile('exclusions/links.txt' ) );
}

sub free {
    my ($me,$link) = @_;
    return $me->_assess($link,$me->{re},1);
}

sub bad {
    my ($me,$link) = @_;
    return $me->_assess($link,$me->{bad},0);
}

sub _assess {
    my ($me,$link,$list,$default) = @_;
    if ($link =~ /^(?:(?:http|ftp):\/\/)?(.+?)\//) {
        $link = $1;
    }
    foreach my $re (@$list) {
        if ($link =~ /$re/i) {
            return !$default;
        }
    }
    return $default;
}
sub freeEntry {

    my ($me,$e) = @_;
    foreach my $l ($e->getLinks) {
        return 1 if $me->free($l);
    }
    return 0;

}

sub file2array {

    my $file = shift;
    open F, $file;
    my @r;
    while (<F>) {
	next if /^\s*#/;
	s/[\n\t]$//g;
	next unless length($_) >= 1;
	push @r,$_;
    }
    close F;
    return \@r;

}



1;
__END__


=head1 NAME

xPapers::Link::Free




=head1 SUBROUTINES

=head2 bad 



=head2 file2array 



=head2 free 



=head2 freeEntry 



=head2 init 



=head2 new 



=head2 site 




=head1 AUTHORS

David Bourget with contributions from Zbigniew Lukasiak



=head1 COPYRIGHT AND LICENSE

See accompanying README file for licensing information.



