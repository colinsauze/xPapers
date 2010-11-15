package xPapers::Parse::BibTeX;

use Text::BibTeX;
use TeX::Encode;
use xPapers::Entry;
use Data::Dumper;
use xPapers::Util;
use HTML::Entities;
use Encode;
use Unicode::Normalize 'compose';
use utf8;

my %map = (
    title => "title",
    year => "date",
    booktitle => "source",
    publisher => "publisher",
    volume => "volume",
    pages => "pages",
    journal => "source",
    school => "school",
);

my %mmap = map { $_ => { map => \%map, fields=> [keys %map] } } qw/book inbook unpublished article incollection phdthesis/;

$mmap{unpublished}->{fields} = ["author","title"];
delete $mmap{incollection}->{map}->{journal};
delete $mmap{inbook}->{map}->{journal};
delete $mmap{article}->{map}->{booktitle};
$mmap{incollection}->{publisher} = "ant_publisher";
$mmap{inbook}->{publisher} = "ant_publisher";
my %typem = (
    book=>["book","book"],
    phdthesis=>["book","thesis"],
    article=>["article","journal"],
    incollection=>["article","chapter"],
    inbook=>["article","chapter"],
    unpublished=>["article","manuscript"]
);

#my ($res,$errors) = parse("/home/xpapers/data/bibs/benj_hellie.bib");
#print "$_\n" for @$errors;
#print "$#$res found.\n";

sub parse {

    my $file = shift();
    die "Couldnt read temp file." unless -r $file;
    my $bibfile = new Text::BibTeX::File;
    $bibfile->open($file,"<:utf8");
    my @errors;
    my @res;
    my @refs;
    my %keys;

    while (my $e = new Text::BibTeX::Entry $bibfile) {

        my ($s,$o) = $e->line;

        if (!$e->parse_ok) {
            push @errors, "Could not parse entry at lines $s-$o. Entry dropped."; 
            next;
        }

        
        my $type = lc $e->type;
        my $m = $mmap{$type};
        if (!$m) {
            push @errors, "Unsupported type (" . $e->type . ") at lines $s-$o. Entry dropped.";
            next;
        }
        my $n = new xPapers::Entry;
        $n->addAuthors(parseAuthors(p($e->get('author'))));
        #print $e->get('editor') . " -- " . p($e->get('editor')) . "<br>" if $e->get('editor');
        if (!$n->firstAuthor and $type eq 'book') {
            $n->edited(1);
            $n->addAuthors(parseAuthors(p($e->get('editor'))));
        } else {
            $n->addEditors(parseAuthors(p($e->get('editor'))));
        }

        $n->addLink(p($e->get('url'))) if $e->get('url');
        $n->isbn([p($e->get('isbn'))]) if $e->get('isbn');
        $n->author_abstract(p($e->get("abstract")));
        my $desc = p($e->get("keywords"));
        $desc =~ s/,/;/g unless $desc =~ /;/;
        $n->descriptors($desc);

        $n->{$m->{map}->{$_}} = p($e->get($_)) for @{$m->{fields}};
        $n->{type} = $typem{$type}->[0]; 
        $n->{pub_type} = $typem{$type}->[1]; 
        $n->{__key} = $e->key;
        $n->{date} = p($e->get('year'));
        $n->{date} =~ s/summer\s*|winter\s*|autumn\s*|fall\s*|spring\s*//ig;
        if ($type eq 'incollection' or $type eq 'inbook') {
            # book info is a ref
            if ($e->get('booktitle') =~ /\\citealt\{([^\}]*)\}/i) {
                push @refs, { from=>$n, to=>  $1 };
            } else {
                $n->{source} = p($e->get('booktitle'));
                $n->{ant_publisher} = p($e->get('publisher'));
                $n->{ant_date} = $n->{date};
                if ($e->get('chapter')) {
                    $n->{source} = p($e->get('title'));
                    $n->{title} = p($e->get('chapter'));
                }
            }
        } elsif ($type eq 'article') {
            $n->{source} = p($e->get('journal'));
            $n->{issue} = p($e->get('number'));
        }
        if ($type eq 'book' and $e->get('volume')) {
            $n->{title} .= " vol. " . p($e->get('volume'));
        }
        if ($n->{date} =~ s!^(\d\d\d\d)/(\d\d\d\d)$!!) {
            $n->{date} = $1;
            $n->{dateRP} = $2;
        }

        # check bogus date
        if ($type ne 'unpublished' and
            $n->{date} !~ /^\d\d\d\d$/ and 
            ! grep { $_ eq $n->{date} } qw/forthcoming manuscript unknown/) {
                my $err = "Invalid publication year ($n->{date}) at lines $s-$o. Use format ORIG/REPRINT for original + reprint date.";
                if ($n->{date} =~ s/^(\d\d\d\d).+/$1/) {
                    $err .= " Assuming $1 is what you mean.";
                    push @errors, $err;
                } else {
                    $err .= " Entry dropped.";
                    push @errors, $err;
                    next;
                }
        }

        # check bogus chars
        if ( join(" ", $n->getAuthors, $n->title, $n->getEditors, $n->volume, $n->source, $n->issue) =~ /([^\w\s]{3,})/) {
           push @errors, "Entry " . $e->key . " at lines $s-$o contains a seemingly bogus string of characters ('" . encode_entities($1) . "'). I'm dropping it.";
           next;
        }

        $keys{$e->key} = $n;
        push @res, $n;

    }

    # inline refs
    for (@refs) {
        my $e = $_->{from};
        my $to = $keys{$_->{to}};
        if (!$to) {
            push @errors, "Entry $e->{__key} refers to a nonexistent entry ($_->{to}). **Continuing with partial info.**"; 
        } else {
            $e->{ant_date} = $to->{date};
            $e->{ant_editors} = $to->{authors};
            $e->{source} = $to->{title};
            $e->{ant_publisher} = $to->{publisher};
        }
    }
    return (\@res,\@errors);
}

sub p {
    my $in = shift;
    return $in unless $in;
    $in =~ s/\\(.)\{(.)\}/{\\$1$2}/g;
    $in =~ s/\\emph\{([^}]*)\}/_$1_/ig;
    return rmTags(compose(TeX::Encode->decode(decode_entities($in))));
}