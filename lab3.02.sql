/*
How many copies of the film Hunchback Impossible exist in the inventory system?
*/

use sakila;
select * from sakila.inventory; 
-- inventory_id, film_id, store_id
select * from sakila.film;
-- film_id, title,
select count(title), i.inventory_id 
from sakila.film as f
join sakila.inventory as i
on f.film_id= i.film_id
where title= 'Hunchback Impossible';


/*
List all films whose length is longer than the average of all the films.
*/

select * from sakila.film;

SELECT AVG(length) FROM sakila.film;
select  title, length from sakila.film
where length > (
  SELECT avg(length)
  FROM sakila.film
);

/*
Use subqueries to display all actors who appear in the film Alone Trip.
*/
select * from sakila.actor;
-- actor_id, last...
select * from sakila.film;
-- film id, title...
select * from sakila.film_actor;
-- actor_id, film_id

select a.actor_id, f.title, a.first_name
from sakila.actor as a
join sakila.film_actor as fa
on fa.actor_id= a.actor_id
join sakila.film as f
on fa.film_id = f.film_id
where f.title= 'Alone Trip';

SELECT * FROM (
  SELECT a.actor_id, title, first_name
  from sakila.actor as a
  join sakila.film_actor as fa 
  on fa.actor_id= a.actor_id
  join sakila.film as f
   on fa.film_id = f.film_id
) sub1
where title= 'Alone Trip';

/*
Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
Identify all movies categorized as family films.
*/

SELECT * from sakila.film;
-- film_id, title
SELECT * from sakila.film_category;
-- film_id, category_id
SELECT * from sakila.category;
-- category_id, name

SELECT name, title 
from sakila.film as f
join sakila.film_category as fc
on f.film_id = fc.film_id
join sakila.category as c
on fc.category_id = c.category_id
where name= 'family';

/*
Get name and email from customers from Canada using subqueries. Do the same with joins.
Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
that will help you get the relevant information.
*/

SELECT * from customer;
-- customer_id, first_name, last_name, adress_id, store_id
SELECT * from address;
-- adress_id, city_id
SELECT * from city;
-- city , city_id, country_id
SELECT * from country;


select first_name, last_name, email, country
from sakila.city as c
join sakila.address as a
on c.city_id= a.city_id
join sakila.customer as cu
on cu.address_id = a.address_id 
join sakila.country as co
on co.country_id = c.country_id
where country = 'canada'; 

  /*
  Which are films starred by the most prolific actor? 
  Most prolific actor is defined as the actor that has acted in the most number of films.
  First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
  */
  select * from sakila.film_actor;
  -- actor_id, film_id
   select * from sakila.film;
   -- film_id, title
   

   

select count(actor_id), title, actor_id
from sakila.film_actor as fa
join sakila.film as f
on f.film_id = fa.film_id
group by actor_id
order by count(actor_id) desc;

/*
Films rented by most profitable customer. 
You can use the customer table and payment table to find the most profitable customer ie the customer 
that has made the largest sum of payments
*/
select customer_id , sum(amount) from payment
group by customer_id
having sum(amount)
order by sum(amount) desc
limit 1;
/*
 Customers who spent more than the average payments
 */
 
 -- step 1 :
 
select avg(amount) from payment;
-- step 2 :
select customer_id from payment
where amount > (select avg(amount) from payment) 
GROUP BY customer_id ;
-- step 3 :
select first_name, last_name, email from customer
where customer_id IN (select customer_id from payment
where amount > (select avg(amount) from payment) 
GROUP BY customer_id);