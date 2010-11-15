
package xPapers::Relations::ThreadUser;  
use base 'xPapers::Object';

__PACKAGE__->meta->setup
(
table   => 'threads_m',
columns =>
    [
        tId => { type => 'integer', not_null => 1 },
        uId => { type => 'integer', not_null => 1 },
    ],

    primary_key_columns   => [ 'tId','uId' ],

    foreign_keys => [
        thread => { class => 'xPapers::Thread', column_map => { tId => 'id' } },
        user => { class => 'xPapers::User', column_map => { uId => 'id' } }
    ],
 
);
