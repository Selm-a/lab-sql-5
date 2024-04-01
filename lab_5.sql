use sakila;

#Drop column picture from staff.
select * from staff;
alter table staff
drop column picture;
select * from staff;

#A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
select * from customer;
select *, customer_id from customer where first_name = "Tammy" and last_name = "Sanders";
select * from staff;
select max(staff_id) from staff;
insert into staff values
		(3, "Tammy", "Sanders", 79, "Tammy.Sanders@sakilastaff.com", 2, 1, "Tammy", Null, "2024-03-06 13:51:16");

# Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. 

select customer_id from sakila.customer
where first_name = 'CHARLOTTE' and last_name = 'HUNTER';

select * from film;
select * from film where title = "Academy Dinosaur";

select * from inventory;
select * from inventory where inventory_id = 1;

select * from rental;
select max(rental_id) from rental;
insert into rental values
		(16050, "2024-03-06 13:51:16", 1, 130, "2024-03-09 13:51:16", 1,"2024-03-06 13:51:16" );
        
#Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, 
#and the date for the users that would be deleted. Follow these steps:

#Check if there are any non-active users

select * from customer;
select * from customer where active != 1;

#Create a table backup table as suggested

create table deleted_users(
		customer_id int unique not null,
        store_id int default null,
        frequency text,
        date int default null,
        constraint primary key(customer_id)
        );
        
alter table deleted_users
        rename column frequency to email;
          alter table deleted_users
        modify email varchar(100);

alter table deleted_users
        drop column store_id;        
        
#Insert the non active users in the table backup table
select * from customer;
select * from customer where active != 1;

insert into deleted_users values
		(16, "SANDRA.MARTIN@sakilacustomer.org", 2006-02-14);
  
insert into deleted_users values
		(64,"JUDITH.COX@sakilacustomer.org", 2006-02-14);

select * from deleted_users;
select * from customer where active != 1;
insert into deleted_users values
		(124, "SHEILA.WELLS@sakilacustomer.org", 2006);
insert into deleted_users values
(169,'ERICA.MATTHEWS@sakilacustomer.org',2006-02-14),
(241,'HEIDI.LARSON@sakilacustomer.org',2006-02-14),
('271','PENNY.NEAL@sakilacustomer.org',2006-02-14),
('315','KENNETH.GOODEN@sakilacustomer.org',2006-02-14 ),
('368','HARRY.ARCE@sakilacustomer.org',2006-02-14),
('406','NATHAN.RUNYON@sakilacustomer.org',2006-02-14),
('446','THEODORE.CULP@sakilacustomer.org',2006-02-14),
('482','MAURICE.CRAWLEY@sakilacustomer.org',2006-02-14),
('510','BEN.EASTER@sakilacustomer.org',2006-02-14),
('534','CHRISTIAN.JUNG@sakilacustomer.org',2006-02-14),
('558','JIMMIE.EGGLESTON@sakilacustomer.org',2006-02-14),
('592','TERRANCE.ROUSH@sakilacustomer.org',2006-02-14);

insert into deleted_users values
(999,'ERICA.MATTHEWS@sakilacustomer.org',"2006-02-14");


#Comment : why the date transform to 1990 ??? 

create table deleted_users as
	select customer_id, email, year(create_date) from customer
    where active = 0;

select * FROM deleted_users; 



#Delete the non active users from the table customer

create temporary table if not exists temp_table as
(select customer_id from customer where active = 0);

select * from temp_table;

delete rental from rental
inner join temp_table on rental.customer_id = temp_table.customer_id;
delete payment from payment
inner join temp_table on payment.customer_id = temp_table.customer_id;

delete customer from customer
inner join temp_table on customer.customer_id = temp_table.customer_id;

select * from customer where active =0;

