-- 1a. Display the first and last names of all actors from the table actor --
use sakila;
select first_name, last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select concat(first_name, ' ', last_name) from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." --
--	What is one query would you use to obtain this information? --
select actor_id, first_name, last_name 
from actor 
where first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN. --
select * 
from actor 
where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. --
-- This time, order the rows by last name and first name, in that order. --
select last_name, first_name 
from actor 
where last_name like '%LI%';

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China. --
select country_id, country 
from country 
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. --
-- Hint: you will need to specify the data type.--
alter table actor
add middle_name varchar(30);
create table actors(
	actor_id int not null auto_increment,
    first_name varchar(30) not null,
    middle_name varchar(30),
    last_name varchar(30) not null,
    primary key(actor_id)
);
insert into actors(actor_id, first_name, middle_name, last_name) 
select actor_id, first_name, middle_name, last_name 
from actor;

-- 3b. You realize that some of these actors have tremendously long last names. --
-- Change the data type of the middle_name column to blobs.--
alter table actors
modify column middle_name blob;

-- 3c. Now delete the middle_name column.--
alter table actors
drop column middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.--
select last_name from actors;
select count(last_name) from actors;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors. --
select last_name, count(*) c from actors group by last_name having c > 1;

-- Turn off safe update mode --
set sql_safe_updates = 0;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, --
-- the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.--
update actors 
set first_name='HARPO' 
where first_name='Groucho' and last_name='Williams';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, --
-- if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, --
-- as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! --
-- (Hint: update the record using a unique identifier.)--
update actors 
set first_name='GROUCHO'
where first_name='Harpo' and last_name='Williams';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it? --
create table address(
	address_id int not null auto_increment,
    address varchar(50) not null,
    address2 varchar(50),
    district varchar(20),
    city_id int(5),
    postal_code varchar(10),
    phone varchar(20),
    location blob,
);

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address. --
select first_name, last_name, address
from staff 
join address on staff.address_id = address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment. --
select first_name, last_name, sum(amount) as  total_amount
from staff join payment
on staff.staff_id = payment.staff_id
where payment.payment_date like '%2005-08%'
group by first_name, last_name;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join. --
select title, count(actor_id) as total_actors
from film join film_actor
on film.film_id = film_actor.film_id
group by title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system? --
select title, count(inventory_id) as total_inventory
from film join inventory
on film.film_id = inventory.film_id
where title='Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. --
-- List the customers alphabetically by last name. --
select last_name, first_name, sum(amount) as  total_amount
from customer join payment
on customer.customer_id = payment.customer_id
group by first_name, last_name
order by last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. --
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. --
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English. --
select title
from film
where (title like 'K%' or title like 'Q%') in 
(select language_id from language where name='English');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip. --
select film_id, title from film where title='Alone Trip';

select first_name, last_name from actors
where actor_id in (select actor_id from film_actor where film_id=17);

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. --
-- Use joins to retrieve this information. --
select first_name, last_name, email
from customer
join address on address.address_id = customer.address_id
join city on city.city_id = address.city_id
join country on country.country_id = city.country_id
where country = 'Canada';

select * from city where country_id=20;
select * from address where city_id=179 or city_id=196
or city_id=300 or city_id=313 or city_id=383
or city_id=430 or city_id=565;
select * from customer where address_id=481 or address_id=468 or 
address_id=1 or  address_id=3 or  address_id=193 or  address_id=415 or 
address_id=441; 
-- how come 1 and 3 don't show up? --

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. --
-- Identify all movies categorized as family films. --
select title from film
join film_category on film.film_id = film_category.film_id
join category on film_category.category_id = category.category_id
where name='Family';

-- 7e. Display the most frequently rented movies in descending order. --
select title, count(rental_id) as total_rentals 
from film
join inventory on inventory.film_id = film.film_id
join rental on rental.inventory_id = inventory.inventory_id
group by title
order by total_rentals desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in. --
select store_id, address, sum(amount) as total_dollars 
from address
join store on store.address_id = address.address_id
join payment on store.manager_staff_id = payment.staff_id
group by store_id;

-- 7g. Write a query to display for each store its store ID, city, and country. --
select store_id, address, city, country
from store
join address on store.address_id = address.address_id
join city on city.city_id = address.city_id
join country on city.country_id = country.country_id
group by store_id;

-- 7h. List the top five genres in gross revenue in descending order. --
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.) --
select name as film_category, sum(amount) as total_revenue
from payment
join rental on rental.rental_id = payment.rental_id
join inventory on inventory.inventory_id = rental.inventory_id
join film_category on film_category.film_id = inventory.film_id
join category on category.category_id = film_category.category_id
group by name
order by total_revenue desc
limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. --
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view. --
create view top_five_genres as
select name as `Film Category`, sum(amount) as `Total Revenue`
from payment
join rental on rental.rental_id = payment.rental_id
join inventory on inventory.inventory_id = rental.inventory_id
join film_category on film_category.film_id = inventory.film_id
join category on category.category_id = film_category.category_id
group by name
order by `Total Revenue` desc
limit 5;

-- 8b. How would you display the view that you created in 8a? --
select * from top_five_genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it. --
drop view top_five_genres; 

-- Turn safe update mode back on --
set sql_safe_updates = 1;