
package xPapers::Relations::InstUser;  
use base 'xPapers::Object';
__PACKAGE__->meta->setup
(
table   => 'areas_m',
columns =>
    [
        aId => { type => 'integer', not_null => 1 },
        mId   => { type => 'integer', not_null => 1 },
    ],

    primary_key_columns   => [ 'aId', 'mId' ],

    foreign_keys => [
        user => { class => 'xPapers::User', column_map => { mId => 'id' } },
        area => { class => 'xPapers::Area', column_map => { aId => 'id' } }
    ],
 
);

