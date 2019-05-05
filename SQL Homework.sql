use sakila;
-- 1a. Display the first and last names of all actors from the table actor.
select first_name, last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
alter table actor
add column Actor_Name varchar (100);
set sql_safe_updates = 0;
update actor set Actor_Name = concat (first_name, " ", last_name);

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name from actor
where first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters GEN:
select * from actor
where last_name like "%G%E%N%";

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select * from actor
where last_name like "%L%I%";
select last_name, first_name from actor;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country 
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Create a column in the table actor named description and use the data type BLOB.
alter table actor
add column description BLOB;
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table actor
drop column description;
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name
HAVING COUNT(*) >= 2;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
select * from information_schema.columns
where table_name = 'address';

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select staff.first_name, staff.last_name, address.address
from staff
join address on
staff.address_id = address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment:
select staff.staff_id, staff.first_name, staff.last_name, payment.payment_date
from staff
join payment on
staff.staff_id = payment.staff_id
where payment_date like "2005%" and payment_date like "%-08-%"; 

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select film.title, film_actor.actor_id
from film_actor
inner join film on
film_actor.film_id = film.film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select film.film_id, film.title, inventory.inventory_id
from film 
inner join inventory on
film.film_id = inventory.film_id
where title = "Hunchback Impossible";

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select customer.customer_id, customer.first_name, customer.last_name, payment.amount
from customer
inner join (
select customer_id, count(*) as mycount,
sum(amount) as mysum
from payment
group by customer_id)
payment on
customer.customer_id = payment.customer_id
order by last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title 
from film
Where title like "k%" or title like "q%"; 

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select Actor_Name
from actor
where actor_id in (
	select actor_id
    from film_actor
    where film_id = 17)
;
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select customer.first_name, customer.last_name, customer.address_id, address.city_id, country.country_id
from customer
join address
on customer.address_id = address.address_id
join city
on address.city_id=city.city_id
join country
on city.country_id = country.country_id
 where country.country_id = 20; 

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title
from film
where film_id in (
	select film_id
    from film_category
    where category_id = 8);