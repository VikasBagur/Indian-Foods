--#1 No of vegetarian and non-veg

SELECT diet, count(*) as No_of_dishes
FROM indian_food
GROUP BY diet
ORDER BY No_of_dishes

--#2 Total in each flavor profile

SELECT flavor_profile, COUNT(*) as No_of_dishes
FROM indian_food
GROUP BY flavor_profile
ORDER BY No_of_dishes

--#3 Total in each course

SELECT course, COUNT(*) as No_of_dishes
FROM indian_food
GROUP BY course
ORDER BY No_of_dishes

--#4 Total dish in each state

SELECT state, COUNT(*) as No_of_dishes
FROM indian_food
GROUP BY state
HAVING state != 'NA'
ORDER BY 2 DESC

--#5 Dish with shortest & longest cook + prep time 

--Shortest
SELECT name, diet, (prep_time + cook_time) as total_time
FROM indian_food
WHERE (prep_time + cook_time) = (SELECT MIN(prep_time + cook_time) FROM indian_food)

--Longest
SELECT name, diet, (prep_time + cook_time) as total_time
FROM indian_food
WHERE (prep_time + cook_time) = (SELECT MAX(prep_time + cook_time) FROM indian_food)
--Alternative to Longest 
SELECT TOP 1 name, diet, (prep_time + cook_time) as total_time
FROM indian_food
WHERE (prep_time + cook_time) is NOT NULL
ORDER BY total_time DESC

--#6 No of ingredients for each dish 
-- & Which dishes have the least amount of ingredients

--Solution 1 is by creating a temp table

DROP TABLE #Ingredients

SELECT name, prep_time, cook_time, 
((CASE WHEN ingredient_1 IS NOT NULL THEN 1 ELSE 0 END)
	+(CASE WHEN ingredient_2 IS NOT NULL THEN 1 ELSE 0 END)
	+(CASE WHEN ingredient_3 IS NOT NULL THEN 1 ELSE 0 END)
	+(CASE WHEN ingredient_4 IS NOT NULL THEN 1 ELSE 0 END)
	+(CASE WHEN ingredient_5 IS NOT NULL THEN 1 ELSE 0 END)
	+(CASE WHEN ingredient_6 IS NOT NULL THEN 1 ELSE 0 END)
	+(CASE WHEN ingredient_7 IS NOT NULL THEN 1 ELSE 0 END)
	+(CASE WHEN ingredient_8 IS NOT NULL THEN 1 ELSE 0 END)
	+(CASE WHEN ingredient_9 IS NOT NULL THEN 1 ELSE 0 END)
	+(CASE WHEN ingredient_10 IS NOT NULL THEN 1 ELSE 0 END)) AS No_of_ingredients
INTO #Ingredients
FROM indian_food
ORDER BY No_of_ingredients

SELECT * 
FROM #Ingredients
WHERE No_of_ingredients = (SELECT MIN(No_of_ingredients) FROM #Ingredients)
ORDER BY No_of_ingredients

--Solution 2: Creating a calculated column

ALTER TABLE indian_food
ADD No_of_ingredients AS ((CASE WHEN ingredient_1 IS NOT NULL THEN 1 ELSE 0 END)
	+(CASE WHEN ingredient_2 IS NOT NULL THEN 1 ELSE 0 END)
	+(CASE WHEN ingredient_3 IS NOT NULL THEN 1 ELSE 0 END)
	+(CASE WHEN ingredient_4 IS NOT NULL THEN 1 ELSE 0 END)
	+(CASE WHEN ingredient_5 IS NOT NULL THEN 1 ELSE 0 END)
	+(CASE WHEN ingredient_6 IS NOT NULL THEN 1 ELSE 0 END)
	+(CASE WHEN ingredient_7 IS NOT NULL THEN 1 ELSE 0 END)
	+(CASE WHEN ingredient_8 IS NOT NULL THEN 1 ELSE 0 END)
	+(CASE WHEN ingredient_9 IS NOT NULL THEN 1 ELSE 0 END)
	+(CASE WHEN ingredient_10 IS NOT NULL THEN 1 ELSE 0 END))

SELECT COUNT(name) as No_of_dishes, No_of_ingredients 
FROM indian_food
GROUP BY No_of_ingredients
ORDER BY No_of_dishes DESC

--#7 Percentage of dishes from each state

SELECT state, COUNT(*) * 100 / (SELECT count(*) FROM indian_food WHERE diet = 'vegetarian') as Percent_of_veg_dishes
FROM indian_food
GROUP BY state
--HAVING diet = 'vegetarian'
--HAVING region != 'NA'
ORDER BY Percent_of_veg_dishes DESC

SELECT state, CAST(COUNT(*) * 100.0 / (SELECT count(*) FROM indian_food WHERE diet = 'non vegetarian') as decimal(5,2)) as Percent_of_nonveg_dishes
FROM indian_food
GROUP BY state, diet
HAVING diet = 'non vegetarian'
--HAVING region != 'NA'
ORDER BY Percent_of_nonveg_dishes DESC