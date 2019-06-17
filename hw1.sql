drop database hw1;
create database hw1;
use hw1;

create table developers (id_developers int AUTO_INCREMENT PRIMARY KEY , name text, age       int, sex boolean);
create table skills		(id_skills     int AUTO_INCREMENT PRIMARY KEY, name text, level     text		     );
create table projects 	(id_projects   int AUTO_INCREMENT PRIMARY KEY, name text, stage     text             );
create table companies	(id_companies  int AUTO_INCREMENT PRIMARY KEY, name text, slogan    text		     );
create table customers  (id_customers  int AUTO_INCREMENT PRIMARY KEY, name text, liquidity int		  		 );
	
create table dev_pro (PRIMARY KEY(id_developers, id_projects ), 
					  id_developers int references developers(id_developers),
                      id_projects int references projects(id_projects)			);

create table dev_ski (PRIMARY KEY(id_developers, id_skills ), 
					  id_developers int references developers(id_developers),
                      id_skills     int references skills    (id_skills)	   
);

create table com_pro (PRIMARY KEY(id_companies, id_projects),
					  id_companies int references companies(id_companies),
                      id_projects  int references projects(id_projects)
);

create table cus_pro (PRIMARY KEY(id_customers, id_projects),
					  id_customers int references customers(id_customers),
                      id_projects  int references projects(id_projects)
);

-- Filling ------------------------------------------------------------------------------------------------

insert into developers values 
(null, 'name1', 15 , true ),
(null, 'name2', 20 , true ),
(null, 'name3', 25 , true ),
(null, 'name4', 30 , true ),
(null, 'name5', 35 , false);

insert into skills values
(null, 'java', 'junior'),
(null, 'java', 'middle'),
(null, 'java', 'senior'),
(null, 'c++' , 'junior'),
(null, 'c++' , 'middle'),
(null, 'c++' , 'senior'),
(null, 'c#'  , 'junior'),
(null, 'c#'  , 'middle'),
(null, 'c#'  , 'senior');

insert into projects value
(null, 'hw1', 'complite'	),
(null, 'hw2', 'complite'	),
(null, 'hw3', 'started'		),
(null, 'hw4', 'not started' );

insert into companies values
(null, 'HWC', 'We do everything'),
(null, 'PPP', 'do anything'		);

insert into customers values
(null, 'sanj', 78),
(null, 'ferb', 12);

insert into dev_pro value
(1,1),
(1,2),
(2,2),
(2,3),
(3,3),
(3,4),
(4,4),
(4,5),
(5,5),
(5,1);

insert into dev_ski values
(1,1),
(1,9),
(2,2),
(2,8),
(3,3),
(3,7),
(4,4),
(4,6),
(5,5),
(5,2);

insert into com_pro values
(1,1),
(1,2),
(1,4),
(2,1),
(2,3),
(2,4);

insert into cus_pro values
(1,1),
(1,2),
(1,4),
(2,1),
(2,3),
(2,4);

-- HW 1.2---------------------------------------------------------------------------------
use hw1;

-- 1
alter table developers add column salary int;
update developers set salary = 1000 where id_developers = 1;
update developers set salary = 1300 where id_developers = 2;
update developers set salary = 4000 where id_developers = 3;
update developers set salary = 2500 where id_developers = 4;
update developers set salary = 4010 where id_developers = 5;
select* FROM developers;

-- 2
Select tab.name, tab.price from 
(
select mp.maxs, pr.id_projects, pr.name, sum(de.salary) price  from projects pr
join dev_pro dp on dp.id_projects = pr.id_projects
join developers de on de.id_developers = dp.id_developers
join 
(
	select max(price) maxs from
	(
	select pr.id_projects,pr.name, sum(de.salary) price  from projects pr
	join dev_pro dp on dp.id_projects = pr.id_projects
	join developers de on de.id_developers = dp.id_developers
	group by pr.id_projects 
	) mp
) mp
group by pr.id_projects 
)  tab
where tab.price = maxs;

-- 3
select sal.name, sum(sal.salary) all_salaryfrom from
(
select sk.name,de.salary from dev_ski ds
join developers de on de.id_developers = ds.id_developers
join skills sk on sk.id_skills = ds.id_skills 
where sk.name = 'java'
) sal ;

-- 4
alter table projects add column cost int ;

update projects pr inner join(
select pr.id_projects,pr.name, sum(de.salary) price  from projects pr
	join dev_pro dp on dp.id_projects = pr.id_projects
	join developers de on de.id_developers = dp.id_developers
	group by pr.id_projects) mp 
    on mp.id_projects = pr.id_projects
    set pr.cost = mp.price
    where pr.id_projects != null; 
;
select* from projects;

-- 5
select pr.name, pr.cost from projects pr
join 
	(
    select min(pr.cost) cost from projects pr
    ) mp
where pr.cost = mp.cost;

-- 6
select av.name , (av.cost/count(av.cost)) average_salary from
(
select pr.name, mp.cost from dev_pro dp
join developers de on dp.id_developers = de.id_developers
join projects pr on dp.id_projects = pr.id_projects
join
	(select pr.id_projects, pr.name, pr.cost from projects pr
		join 
		(
		select min(pr.cost) cost from projects pr
		) mp
	where pr.cost = mp.cost
	)mp 
    on mp.id_projects = pr.id_projects
) av
;