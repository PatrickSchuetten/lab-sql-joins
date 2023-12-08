-- ## Challenge - Joining on multiple tables

-- Write SQL queries to perform the following tasks using the Sakila database:
USE sakila;

-- 1. List the number of films per category.
SELECT count(*) FROM film;
SELECT count(DISTINCT(film_id)) FROM film;
SELECT count(*) FROM film_category;
SELECT count(DISTINCT(film_id)) FROM film_category;
-- > inner join because they have the same amount of rows and every film id shoud have one category
SELECT category_id, count(title) FROM film AS f
JOIN film_category AS fc
ON f.film_id = fc.film_id
GROUP BY category_id
ORDER BY category_id;
-- > adding the categorical table as a left join because we want all the information from the join before and add the information from category
SELECT c.name, count(title) AS 'Number of films' FROM film AS f
JOIN film_category AS fc
ON f.film_id = fc.film_id
JOIN category AS c
ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY count(title) DESC;


-- 2. Retrieve the store ID, city, and country for each store.
-- store ID --> store
-- address as connector 
-- city --> city
-- country --> country

SELECT store_id, city, country FROM store AS s
JOIN address as a
ON s.address_id=a.address_id
JOIN city AS ci
ON a.city_id=ci.city_id
JOIN country AS co
ON ci.country_id=co.country_id;





-- 3.  Calculate the total revenue generated by each store in dollars.
-- total revenue --> count(amount) from payment    left join because we want all the payments 
-- staff as connector 
-- store_id --> store
SELECT sto.store_id, count(p.amount) FROM payment AS p
LEFT JOIN staff AS sta
ON p.staff_id = sta.staff_id
JOIN store AS sto
ON sta.store_id=sto.store_id
GROUP BY sto.store_id;

-- 4.  Determine the average running time of films for each category.
-- avg(length) -->   film
-- film_category as connector
-- name --> category

SELECT c.name, round(avg(f.length),2) AS 'average running time' FROM film AS f
LEFT JOIN film_category AS fc
ON f.film_id=fc.film_id
JOIN category AS c
ON fc.category_id=c.category_id
GROUP BY c.name
ORDER BY avg(f.length) DESC;

-- **Bonus**:

-- 5.  Identify the film categories with the longest average running time.

SELECT c.name, round(avg(f.length),2) AS 'average running time' FROM film AS f
LEFT JOIN film_category AS fc
ON f.film_id=fc.film_id
JOIN category AS c
ON fc.category_id=c.category_id
GROUP BY c.name
HAVING 'average running time' = max('average running time')
ORDER BY avg(f.length) DESC;

-- 6.  Display the top 10 most frequently rented movies in descending order.
-- title --> film
-- count(inventory_id) --> inventory
SELECT inventory_id, film_id FROM inventory; -- for each film there can be multiple inventory_id's
SELECT rental_id, inventory_id FROM rental;  -- for each inventory_id there can be multiple rental_id's
-- so i make a left join from rental + inventory and a left join from inventory + film
SELECT title, count(title) FROM rental AS r
LEFT JOIN inventory AS i
ON r.inventory_id = i.inventory_id
LEFT JOIN film AS f
ON i.film_id = f.film_id
GROUP BY title
ORDER BY count(title) DESC
LIMIT 10;


-- 7. Determine if "Academy Dinosaur" can be rented from Store 1.

-- if condition title = "Academy Dinosaur" AND store_id =1 
-- store_id --> store
-- inventory as connector table
-- title from film

-- film +left+ inventory +left+ store

SELECT * FROM film AS f
LEFT JOIN inventory AS i
ON f.film_id = i.film_id
LEFT JOIN store AS s
ON i.store_id = s.store_id
WHERE f.title="Academy Dinosaur" AND s.store_id = 1;
-- yes it can be rented in store 1

-- 8. Provide a list of all distinct film titles, along with their availability status in the inventory. Include a column indicating whether each title is 'Available' or 'NOT available.' Note that there are 42 titles that are not in the inventory, and this information can be obtained using a `CASE` statement combined with `IFNULL`."
-- title --> film
-- inventory_id --> inventory
-- film +left+ inventory

-- all titles with their availability
SELECT title, 
CASE 
	WHEN i.inventory_id > 0 THEN 'Available'
    ELSE 'NOT available'
END AS Availability
FROM film as f
LEFT JOIN inventory as i
ON f.film_id = i.film_id;


-- all titles which are not available
SELECT * FROM (
SELECT title, 
CASE 
	WHEN i.inventory_id > 0 THEN 'Available'
    ELSE 'NOT available'
END AS Availability
FROM film as f
LEFT JOIN inventory as i
ON f.film_id = i.film_id
) AS sub1
WHERE Availability ='NOT available';


-- Here are some tips to help you successfully complete the lab:

-- ***Tip 1***: This lab involves joins with multiple tables, which can be challenging. Take your time and follow the steps we discussed in class:

-- - Make sure you understand the relationships between the tables in the database. This will help you determine which tables to join and which columns to use in your joins.
-- - Identify a common column for both tables to use in the `ON` section of the join. If there isn't a common column, you may need to add another table with a common column.
-- - Decide which table you want to use as the left table (immediately after `FROM`) and which will be the right table (immediately after `JOIN`).
-- - Determine which table you want to include all records from. This will help you decide which type of `JOIN` to use. If you want all records from the first table, use a `LEFT JOIN`. If you want all records from the second table, use a `RIGHT JOIN`. If you want records from both tables only where there is a match, use an `INNER JOIN`.
-- - Use table aliases to make your queries easier to read and understand. This is especially important when working with multiple tables.
-- - Write the query

-- ***Tip 2***: Break down the problem into smaller, more manageable parts. For example, you might start by writing a query to retrieve data from just two tables before adding additional tables to the join. Test your queries as you go, and check the output carefully to make sure it matches what you expect. This process takes time, so be patient and go step by step to build your query incrementally.