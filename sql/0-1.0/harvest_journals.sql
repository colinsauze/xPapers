create table harvest_journals ( id int unsigned auto_increment primary key, issn varchar(16), issn2 varchar(16), name varchar(255), localName varchar(255), publisher varchar(255), subjects text, doi varchar(255), inCrossRef bool, lastFound datetime, lastIssue varchar(255), deleted char(1) default 0, toHarvest bool) character set utf8;
alter table harvest_journals add index( issn );
alter table harvest_journals add index( inCrossRef );
ALTER TABLE harvest_journals ADD FULLTEXT(name,subjects);
alter table harvest_journals add index( name );
alter table harvest_journals add oai_set varchar(128);
alter table harvest_journals add lastSuccess datetime;
alter table harvest_journals add index( oai_set );
alter table harvest_journals add fetched integer default 0;
insert into harvest_journals ( name, inCrossRef, oai_set, deleted ) values ( 'TEST', true, 'TEST', 1 );
alter table harvest_journals add nonEng integer default 0;
alter table harvest_journals add newEntries integer default 0;
alter table harvest_journals add oldEntries integer default 0;
alter table harvest_journals add origin char(1);
alter table harvest_journals add noTitle integer default 0;
alter table harvest_journals add suggestion tinyint(1) unsigned default 0;

