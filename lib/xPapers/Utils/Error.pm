package xPapers::Utils::Error;
use base qw/xPapers::Object/;

#__PACKAGE__->meta->table('errors');
#__PACKAGE__->meta->auto_initialize;
#print __PACKAGE__->meta->perl_class_definition(indent => 2, braces => 'bsd');

__PACKAGE__->meta->setup
(
table   => 'errors',

columns => 
[
    id          => { type => 'integer', not_null => 1 },
    ip          => { type => 'varchar', length => 15 },
    host        => { type => 'varchar', length => 255 },
    uId         => { type => 'integer' },
    type        => { type => 'integer' },
    pid         => { type => 'integer' },
    request_uri => { type => 'varchar', length => 2000 },
    referer     => { type => 'varchar', length => 2000 },
    user_agent  => { type => 'varchar', length => 2000 },
    args        => { type => 'text', length => 65535 },
    cookies     => { type => 'text', length => 65535 },
    time        => { type => 'timestamp' },
    info   => { type => 'text', length => 65535 },
],

primary_key_columns => [ 'id' ],
);

1;

package xPapers::ER;

use base qw(Rose::DB::Object::Manager);

sub object_class { 'xPapers::Utils::Error' }

__PACKAGE__->make_manager_methods('errors');

1;



__END__


=head1 NAME

xPapers::Utils::Error

=head1 DESCRIPTION

Inherits from: L<xPapers::Object>

Table: errors


=head1 FIELDS

=head2 args (text): 



=head2 cookies (text): 



=head2 host (varchar): 



=head2 id (integer): 



=head2 info (text): 



=head2 ip (varchar): 



=head2 pid (integer): 



=head2 referer (varchar): 



=head2 request_uri (varchar): 



=head2 time (timestamp): 



=head2 type (integer): 



=head2 uId (integer): 



=head2 user_agent (varchar): 







=head1 AUTHORS

David Bourget with contributions from Zbigniew Lukasiak



=head1 COPYRIGHT AND LICENSE

See accompanying README file for licensing information.



