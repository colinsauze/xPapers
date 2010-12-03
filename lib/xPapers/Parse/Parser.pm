#!/usr/local/bin/perl
package Parser;
use xPapers::Entry;
use xPapers::Legacy::Biblio;
use xPapers::Legacy::Category;

sub new {
 	my $class = shift;
 	my $self = {
     	inputType => "NONE",
        class=>$class,
	};
	bless $self, $class;
	return $self;
}

sub parseEntryFirstLine {
	my ($self, $text) = @_;
 	# do something with the text ..
 	# then return an entry object with the proper type
 	return xPapers::Entry->new(type=>"article");
}

sub parseEntryExtraLine {
	my ($self, $entry, $text) = @_;
 	# do something with the text ..
 	return $entry;
}

sub parseEntryMultiLine {
	my ($self, $text) = @_;
 	# do something with the text ..
 	# then return an entry object with the proper type
 	return $entry;
}

sub parseCategory {
	my ($self,$text) = @_;
	return Category->new;
}

sub parseBiblio {
	my ($self, $text) = @_;
	# do something ..
	return Biblio->new;
}
1;
__END__

=head1 NAME



=head1 SYNOPSIS



=head1 DESCRIPTION






=head1 DIAGNOSTICS

=head1 AUTHORS



=head1 COPYRIGHT AND LICENSE

See accompanying README file for licensing information.



