insert into student2 values (56789,'abcd',50);
select * from student2 where name = "name90000";

create index stunameidx on student2 ( name );
select * from student2 where name = "name90000";
delete from student2;

drop index stunameidx on student2;

select * from student2 where score = 100;
