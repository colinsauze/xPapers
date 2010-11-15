
package xPapers::Relations::EntryArea;  
use base 'xPapers::Object';
__PACKAGE__->meta->setup
(
table   => 'areas_me',
columns =>
    [
        aId => { type => 'integer', not_null => 1 },
        mId   => { type => 'integer', not_null => 1 },
    ],

    primary_key_columns   => [ 'aId', 'mId' ],

    foreign_keys => [
        entry => { class => 'xPapers::Entry', column_map => { mId => 'id' } },
        area => { class => 'xPapers::Area', column_map => { aId => 'id' } }
    ],
 
);


1
