USE publications;

SHOW TABLES;
SELECT * FROM AUTHORS;
SELECT * FROM titleauthor;
SELECT * FROM PUBLISHERS;

-- 1.  ¿Quién ha publicado qué y dónde?
SELECT au.au_id AS 'AUTHOR ID', au.au_lname AS 'LAST NAME', au.au_fname AS 'FIRST NAME', t.title AS 'TITLE', pb.pub_name AS 'PUBLISHER'
FROM authors AS au
LEFT JOIN
titleauthor AS ta
	ON au.au_id = ta.au_id    

LEFT JOIN
titles AS t
	ON ta.title_id = t.title_id 
    
-- connect table titles & publishers using pub_id
LEFT JOIN
publishers AS pb
	ON t.pub_id = pb.pub_id
;


-- 2.  ¿Quién ha publicado cuántos y dónde?
-- from the first table generated, remove the title and add the title count 

SELECT au.au_id AS 'AUTHOR ID', au.au_lname AS 'LAST NAME', au.au_fname AS 'FIRST NAME', pb.pub_name AS 'PUBLISHER', count(t.title) AS 'TITLE COUNT'
FROM authors AS au
LEFT JOIN
titleauthor AS ta
	ON au.au_id = ta.au_id

LEFT JOIN
titles AS t
	ON ta.title_id = t.title_id 
    
-- connect table titles & publishers using pub_id
LEFT JOIN
publishers AS pb
	ON t.pub_id = pb.pub_id

WHERE pb.pub_name IS NOT NULL
GROUP BY au.au_id, au.au_lname, au.au_fname, pb.pub_name
ORDER BY au.au_id DESC
;

-- 3. Desafío 3 -Quiénes son los 3 principales autores que han vendido el mayor número de títulos? Escribe una consulta para averiguarlo.
-- Requisitos:
	-- Tu salida debería tener las siguientes columnas:
	-- AUTHOR ID - el ID del autor
	-- LAST NAME - apellido del autor
	-- FIRST NAME - nombre del autor
	-- TOTAL - número total de títulos vendidos de este autor
		-- Tu salida debería estar ordenada basándose en TOTAL de mayor a menor.
		-- Solo muestra los 3 mejores autores en ventas.

SELECT * FROM sales;
SELECT au.au_id AS 'AUTHOR ID', au.au_lname AS 'LAST NAME', au.au_fname AS 'FIRST NAME', SUM(s.qty) AS 'TOTAL'
FROM authors AS au
LEFT JOIN
titleauthor AS ta
	ON au.au_id = ta.au_id
    
LEFT JOIN
titles AS t
	ON ta.title_id = t.title_id 
    
-- join sales with titles with columns 'title id'
LEFT JOIN
sales AS s
	ON t.title_id = s.title_id

WHERE s.qty IS NOT NULL
GROUP BY au.au_id
ORDER BY SUM(s.qty) DESC
LIMIT 3
;

-- 4.  Ranking de Autores Más Vendidos
-- Ahora modifica tu solución en el Desafío 3 para que la salida muestre a todos los 23 autores en lugar de solo los 3 principales.
-- Ten en cuenta que los autores que han vendido 0 títulos también deben aparecer en tu salida (idealmente muestra 0 en lugar de NULL como TOTAL). 
-- También ordena tus resultados basándose en TOTAL de mayor a menor.

SELECT DISTINCT au.au_id AS 'AUTHOR ID', au.au_lname AS 'LAST NAME', au.au_fname AS 'FIRST NAME', coalesce(SUM(s.qty),0) AS 'TOTAL'
FROM authors AS au
LEFT JOIN
titleauthor AS ta
	ON au.au_id = ta.au_id
    
LEFT JOIN
titles AS t
	ON ta.title_id = t.title_id 
    
-- join sales with titles with columns 'title id'
LEFT JOIN
sales AS s
	ON t.title_id = s.title_id

GROUP BY au.au_id
ORDER BY SUM(s.qty) DESC
;