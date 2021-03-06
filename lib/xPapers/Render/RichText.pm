package xPapers::Render::RichText;

use vars qw/@ISA @EXPORT @EXPORT_OK/;
use xPapers::Util qw/rmTags reverseName/;
use HTML::Entities;
use xPapers::Render::HTML;
use xPapers::Render::HTML;
use strict;

@ISA = qw/xPapers::Render::HTML/;

sub new {
  my ($class) = @_;
  my $self = $class->SUPER::new();
  $self->{linkNames} = 0;
  $self->{compactAuthors} = 0;
  $self->{compact} = 0;
  $self->{level} = 0;
  $self->{subGroups} = 0;
  $self->{entriesInGroup} = 0;
  bless $self, $class;
  return $self;
}

sub renderEntry {
    my ($me,$e) = @_;

    my $r = rmTags($me->renderAuthors($e->getAuthors));
    $r =~ s/\s+$//;
    if ( $e->{pub_type} =~ /(journal|book|chapter|thesis|online collection)/) {
        $r .= " ($e->{date}). ";
    } else {
        $r .= ", ";
    }
    if ($e->{pub_type} =~ /(book|thesis)/) {
        $r .= "<i>$e->{title}</i>";
    } else {
        $r .= $e->{title};
    }
    $r =~ s/_([^_]+)_/<i>$1<\/i>/g;
    $r =~ s/\s+$//g;
    $r .= "." unless $r =~ /[\?\!\.]$/;
    $r .= $me->prepPubInfo($e);
    decode_entities($r);
    $r =~ s/\s+/ /g;
    return "$r<br>";
}

sub afterEntry {
    my ($me,$e) = @_;
    return "";
}


sub beginCategory { };
sub endCategory { };
sub startBiblio { return "<style>.pub_name { font-style: italic }</style>\n" };
sub endBiblio { };
sub headerId { };
sub renderHeader {};
sub beforeGroup {};
sub afterGroup {};
sub entryId { my ($me,$e) = @_; return $e->id };
sub renderNav {};
sub nothingMsg {};
sub renderCatHeading {};
sub renderNameLit {
    my ($me,$name) = @_;
    my $r = reverseName($name);
    my $l = "<a class='person' href=\"?searchStr=$name&filterMode=authors\">$r</a>";
    return $l;
}


1;
__END__


=head1 NAME

xPapers::Render::RichText




=head1 SUBROUTINES

=head2 afterEntry 



=head2 afterGroup 



=head2 beforeGroup 



=head2 beginCategory 



=head2 endBiblio 



=head2 endCategory 



=head2 entryId 



=head2 headerId 



=head2 new 



=head2 nothingMsg 



=head2 renderEntry 



=head2 renderHeader 



=head2 renderNameLit 



=head2 renderNav 



=head2 startBiblio 




=head1 AUTHORS

David Bourget with contributions from Zbigniew Lukasiak



=head1 COPYRIGHT AND LICENSE

See accompanying README file for licensing information.



