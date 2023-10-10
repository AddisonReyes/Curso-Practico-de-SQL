/*
	Todos los querys del curso 'Curso Práctico de SQL' de Platzi, clases y ejercicios.
	~Addison Reyes
*/



--Clase #1 "El primero"
SELECT * 
FROM platzi.alumnos 
FETCH FIRST 1 ROWS ONLY;
--
SELECT * 
FROM platzi.alumnos 
LIMIT 1;
--
SELECT * 
FROM (
	SELECT ROW_NUMBER() OVER() AS row_id, * 
	FROM platzi.alumnos
) AS alumnos_with_row_num 
WHERE row_id = 1;


--Ejercicios
SELECT * 
FROM platzi.alumnos 
FETCH FIRST 5 ROWS ONLY;
--
SELECT * 
FROM platzi.alumnos 
LIMIT 5;
--
SELECT * FROM (
	SELECT ROW_NUMBER() OVER() AS row_id, * 
	FROM platzi.alumnos
) AS alumnos_with_row_num 
WHERE row_id < 6;




--Clase #2 "El segundo más alto"
SELECT DISTINCT colegiatura 
FROM platzi.alumnos AS a1 
WHERE 2 = (
	SELECT COUNT (DISTINCT colegiatura) 
	FROM platzi.alumnos a2 
	WHERE a1.colegiatura <= a2.colegiatura
);
--
SELECT DISTINCT colegiatura, tutor_id
FROM platzi.alumnos 
WHERE tutor_id = 20
ORDER BY colegiatura DESC 
LIMIT 1 OFFSET 1;
--
SELECT * 
FROM platzi.alumnos AS datos_alumnos 
INNER JOIN (
	SELECT DISTINCT colegiatura
	FROM platzi.alumnos
	WHERE tutor_id = 20
	ORDER BY colegiatura DESC 
	LIMIT 1 OFFSET 1
) AS segunda_mayor_colegiatura
ON datos_alumnos.colegiatura = segunda_mayor_colegiatura.colegiatura;
--
SELECT *
FROM platzi.alumnos AS datos_alumnos
WHERE colegiatura = (
	SELECT DISTINCT colegiatura
	FROM platzi.alumnos
	WHERE tutor_id = 20
	ORDER BY colegiatura DESC
	LIMIT 1 OFFSET 1
);


--Ejercicio

--Mi solucion
SELECT id, *
FROM platzi.alumnos
WHERE id > (
	SELECT COUNT(id) / 2
	FROM platzi.alumnos
);
--Solucion del curso
SELECT ROW_NUMBER() OVER() AS row_id, *
FROM platzi.alumnos
OFFSET(
	SELECT COUNT(*)/2
	FROM platzi.alumnos
);


--Clase #3 "Seleccionar de un set de opciones"
SELECT *
FROM (
	SELECT ROW_NUMBER() OVER() AS row_id, *
	FROM platzi.alumnos
) AS alumnos_with_row
WHERE row_id IN (1, 5, 10, 12, 15, 20);
--
SELECT * 
FROM platzi.alumnos
WHERE id IN (
	SELECT id
	FROM platzi.alumnos
	WHERE tutor_id = 30
);
--
SELECT * 
FROM platzi.alumnos
WHERE id IN (
	SELECT id
	FROM platzi.alumnos
	WHERE tutor_id = 30
	AND carrera_id = 31
);


--Ejercicio
SELECT * 
FROM platzi.alumnos
WHERE id NOT IN (
	SELECT id
	FROM platzi.alumnos
	WHERE tutor_id = 30
);



--Clase #4 "En mis tiempos"
SELECT EXTRACT (YEAR FROM fecha_incorporacion) AS anio_incorporacion
FROM platzi.alumnos
--
SELECT DATE_PART('YEAR', fecha_incorporacion) AS anio_incorporacion
FROM platzi.alumnos;
--
SELECT DATE_PART('YEAR', fecha_incorporacion) AS anio_incorporacion,
	DATE_PART('MONTH', fecha_incorporacion) AS mes_incorporacion,
	DATE_PART('DAY', fecha_incorporacion) AS dia_incorporacion
FROM platzi.alumnos;
--
SELECT DATE_PART('DAY', fecha_incorporacion) AS dia_incorporacion,
	DATE_PART('MONTH', fecha_incorporacion) AS mes_incorporacion,
	DATE_PART('YEAR', fecha_incorporacion) AS anio_incorporacion
FROM platzi.alumnos;


--Ejercicios
SELECT DATE_PART('SECOND', fecha_incorporacion) AS segundo_incorporacion,
	DATE_PART('MINUTE', fecha_incorporacion) AS minuto_incorporacion,
	DATE_PART('HOUR', fecha_incorporacion) AS hour_incorporacion
FROM platzi.alumnos;




--Clase #5 "Seleccionar por año"
SELECT *
FROM platzi.alumnos
WHERE (EXTRACT (YEAR FROM fecha_incorporacion)) = 2018;
--
SELECT *
FROM platzi.alumnos
WHERE (DATE_PART('YEAR', fecha_incorporacion)) = 2019;
--
SELECT *
FROM (
	SELECT *,
		DATE_PART('YEAR',fecha_incorporacion) AS anio_incorporacion
	FROM platzi.alumnos
) AS alumnos_con_anio
WHERE anio_incorporacion = 2020;


--Ejercicios

--Mi solucion
SELECT *
FROM platzi.alumnos
WHERE (DATE_PART('YEAR', fecha_incorporacion)) = 2018
AND (DATE_PART('MONTH', fecha_incorporacion)) = 5;
--Solucion del curso
SELECT *
FROM (
	SELECT *,
		DATE_PART('YEAR',fecha_incorporacion) AS anio_incorporacion,
		DATE_PART('MONTH',fecha_incorporacion) AS mes_incorporacion
	FROM platzi.alumnos
) AS alumnos_con_anio
WHERE anio_incorporacion = 2018
AND mes_incorporacion = 5;



--Clase #6 "Duplicados"
insert into platzi.alumnos (id, nombre, apellido, email, colegiatura, fecha_incorporacion, carrera_id, tutor_id) values (1001, 'Pamelina', null, 'pmylchreestrr@salon.com', 4800, '2020-04-26 10:18:51', 12, 16);
--
SELECT *
FROM platzi.alumnos AS ou
WHERE (
	SELECT COUNT(*)
	FROM platzi.alumnos AS inr
	WHERE ou.id = inr.id
) > 1;
--
SELECT (
	platzi.alumnos.nombre,
	platzi.alumnos.apellido,
	platzi.alumnos.email,
	platzi.alumnos.colegiatura,
	platzi.alumnos.fecha_incorporacion,
	platzi.alumnos.carrera_id,
	platzi.alumnos.tutor_id
)::text, COUNT(*)
FROM platzi.alumnos
GROUP BY 
	platzi.alumnos.nombre,
	platzi.alumnos.apellido,
	platzi.alumnos.email,
	platzi.alumnos.colegiatura,
	platzi.alumnos.fecha_incorporacion,
	platzi.alumnos.carrera_id,
	platzi.alumnos.tutor_id
HAVING COUNT(*) > 1;
--
SELECT *
FROM (
	SELECT id,
	ROW_NUMBER() OVER(
		PARTITION BY
			nombre,
			apellido,
			email,
			colegiatura,
			fecha_incorporacion,
			carrera_id,
			tutor_id
		ORDER BY
			id
		ASC
	) AS row,
	*
	FROM platzi.alumnos
) AS duplicados
WHERE duplicados.row > 1;


--Ejercicios
--Mi solucion
DELETE FROM platzi.alumnos
WHERE id = (
	SELECT id
	FROM (
		SELECT *
		FROM (
			SELECT id,
			ROW_NUMBER() OVER(
				PARTITION BY
					nombre,
					apellido,
					email,
					colegiatura,
					fecha_incorporacion,
					carrera_id,
					tutor_id
				ORDER BY
					id
				ASC
			) AS row--,
			--*
			FROM platzi.alumnos
		) AS duplicados
		WHERE duplicados.row > 1
	)
);
--Solucion del curso
DELETE FROM platzi.alumnos
WHERE id IN (
	SELECT id
	FROM (
		SELECT id,
		ROW_NUMBER() OVER(
			PARTITION BY
				nombre,
				apellido,
				email,
				colegiatura,
				fecha_incorporacion,
				carrera_id,
				tutor_id
			ORDER BY
				id
			ASC
		) AS row
		FROM platzi.alumnos
	) AS duplicados
	WHERE duplicados.row > 1
);




--Clase #7 "Selectores de rango"
SELECT *
FROM platzi.alumnos
WHERE tutor_id IN (1, 2, 3, 4, 5, 6);
--
SELECT *
FROM platzi.alumnos
WHERE tutor_id >= 1
AND tutor_id <= 10;
--
SELECT *
FROM platzi.alumnos
WHERE tutor_id BETWEEN 1 AND 10;
--
SELECT int4range(1, 20) @> 3;
--
SELECT numrange(11.1, 22.2) && numrange(20.0, 30.0);
SELECT numrange(11.1, 19.9) && numrange(20.0, 30.0);
--
SELECT UPPER(int8range(15, 25));
SELECT LOWER(int8range(15, 25));
--
SELECT int4range(10, 20) * int4range(15, 25);
SELECT int4range(10, 20);
SELECT int8range(15, 25);
--
SELECT ISEMPTY(numrange(1, 5));
--
SELECT * 
FROM platzi.alumnos
WHERE int4range(10, 20) @> tutor_id;


--Ejercicios
SELECT int4range(MIN(tutor_id), MAX(tutor_id)) * int4range(MIN(carrera_id), MAX(carrera_id))
FROM platzi.alumnos;
--
SELECT numrange(
	(SELECT MIN(tutor_id) FROM platzi.alumnos),
	(SELECT MAX(tutor_id) FROM platzi.alumnos)
) * numrange(
	(SELECT MIN(carrera_id) FROM platzi.alumnos),
	(SELECT MAX(carrera_id) FROM platzi.alumnos)
)



--Clase #8 "Eres lo máximo"
SELECT fecha_incorporacion
FROM platzi.alumnos
ORDER BY fecha_incorporacion DESC
LIMIT 1;
--
SELECT carrera_id, fecha_incorporacion
FROM platzi.alumnos
GROUP BY carrera_id, fecha_incorporacion
ORDER BY fecha_incorporacion DESC;
--
SELECT carrera_id, 
	MAX(fecha_incorporacion)
FROM platzi.alumnos
GROUP BY carrera_id
ORDER BY carrera_id;


--Ejercicios
SELECT MIN(nombre)
FROM platzi.alumnos
--
SELECT MIN(nombre), tutor_id
FROM platzi.alumnos
GROUP BY tutor_id
ORDER BY tutor_id




--Clase #9 "Egoísta (selfish)"
SELECT 
	CONCAT(a.nombre, ' ', a.apellido) AS alumno, 
	CONCAT(t.nombre, ' ', t.apellido) AS tutor
FROM platzi.alumnos AS a
	INNER JOIN platzi.alumnos AS t ON a.tutor_id = t.id;
--
SELECT 
	CONCAT(t.nombre, ' ', t.apellido) AS tutor,
	COUNT(*) AS alumnos_por_tutor
FROM platzi.alumnos AS a
	INNER JOIN platzi.alumnos AS t ON a.tutor_id = t.id
GROUP BY tutor
ORDER BY alumnos_por_tutor DESC
LIMIT 10;

--Ejercicio
SELECT AVG(alumnos_por_tutor) AS alumnos_por_tutor
FROM (
	SELECT 
		CONCAT(t.nombre, ' ', t.apellido) AS tutor,
		COUNT(*) AS alumnos_por_tutor
	FROM platzi.alumnos AS a
		INNER JOIN platzi.alumnos AS t ON a.tutor_id = t.id
	GROUP BY tutor
) AS alumnos_tutor;



--Clase #10 "Resolviendo diferencias"
SELECT carrera_id, COUNT(*) AS cuenta
FROM platzi.alumnos
GROUP BY carrera_id
ORDER BY cuenta DESC;
--
--DELETE FROM platzi.carreras
--WHERE id BETWEEN 30 AND 40;
--
SELECT 
	a.nombre,
	a.apellido,
	a.carrera_id,
	c.id,
	c.carrera
FROM platzi.alumnos AS a
	LEFT JOIN platzi.carreras AS c
	ON a.carrera_id = c.id
WHERE c.id IS NULL;
--
SELECT 
	a.nombre,
	a.apellido,
	a.carrera_id,
	c.id,
	c.carrera
FROM platzi.alumnos AS a
	LEFT JOIN platzi.carreras AS c
	ON a.carrera_id = c.id
WHERE c.id IS NULL
ORDER BY a.carrera_id;


--Ejercicio
SELECT 
	a.nombre,
	a.apellido,
	a.carrera_id,
	c.id,
	c.carrera
FROM platzi.alumnos AS a
	FULL OUTER JOIN platzi.carreras AS c
	ON a.carrera_id = c.id
ORDER BY a.carrera_id;




--Clase #11
SELECT
	a.nombre,
	a.apellido,
	a.carrera_id,
	c.id,
	c.carrera
FROM platzi.alumnos AS a
	LEFT JOIN platzi.carreras AS c
	ON a.carrera_id = c.id
WHERE c.id IS NULL;
--
SELECT
	a.nombre,
	a.apellido,
	a.carrera_id,
	c.id,
	c.carrera
FROM platzi.alumnos AS a
	LEFT JOIN platzi.carreras AS c
	ON a.carrera_id = c.id
ORDER BY c.id DESC;
--
SELECT
	a.nombre,
	a.apellido,
	a.carrera_id,
	c.id,
	c.carrera
FROM platzi.alumnos AS a
	RIGHT JOIN platzi.carreras AS c
	ON a.carrera_id = c.id
ORDER BY c.id DESC;
--
SELECT
	a.nombre,
	a.apellido,
	a.carrera_id,
	c.id,
	c.carrera
FROM platzi.alumnos AS a
	RIGHT JOIN platzi.carreras AS c
	ON a.carrera_id = c.id
WHERE a.id IS NULL
ORDER BY c.id DESC;
--
SELECT
	a.nombre,
	a.apellido,
	a.carrera_id,
	c.id,
	c.carrera
FROM platzi.alumnos AS a
	JOIN platzi.carreras AS c
	ON a.carrera_id = c.id
ORDER BY c.id DESC;
--
SELECT
	a.nombre,
	a.apellido,
	a.carrera_id,
	c.id,
	c.carrera
FROM platzi.alumnos AS a
	FULL OUTER JOIN platzi.carreras AS c
	ON a.carrera_id = c.id
WHERE a.id is NULL 
	OR c.id IS NULL
ORDER BY c.id DESC;




--Clase #12 "Triangulando"
SELECT lpad('sql', 16, '*');
--
SELECT lpad('sql', id, '*')
FROM platzi.alumnos
WHERE id < 10;
--
SELECT lpad('*', id, '*')
FROM platzi.alumnos
WHERE id < 10;
--
SELECT lpad('*', id, '*'), carrera_id
FROM platzi.alumnos
WHERE id < 10
ORDER BY carrera_id;
--
SELECT *
FROM (
	SELECT ROW_NUMBER() OVER() AS row_id, *
	FROM platzi.alumnos
) AS alumnos_with_row_id
WHERE row_id <= 6;
--
SELECT lpad('*', CAST(row_id AS int), '*')
FROM (
	SELECT ROW_NUMBER() OVER(
		ORDER BY carrera_id
	) AS row_id, *
	FROM platzi.alumnos
) AS alumnos_with_row_id
WHERE row_id <= 6
ORDER BY carrera_id;

--Ejercicios
SELECT rpad('sql', id, '*')
FROM platzi.alumnos
WHERE id < 10;



--Clase #13 "Generando rangos"
SELECT *
FROM generate_series(1, 6);
--
SELECT *
FROM generate_series(5, 1, -2);
--
SELECT *
FROM generate_series(3, 4, 1);
--
SELECT *
FROM generate_series(1.1, 4, 1.3);
--
SELECT current_date + s.a AS dates
FROM generate_series(0, 14, 7) AS s(a);
--
SELECT * 
FROM generate_series('2020-09-01'::timestamp,
					 '2020-09-04', '10 hours');
--
SELECT 
	a.id,
	a.nombre,
	a.apellido,
	a.carrera_id,
	s.a
FROM platzi.alumnos AS a
	INNER JOIN generate_series(9, 10) AS s(a)
	ON s.a = a.carrera_id
ORDER BY a.carrera_id;


--Ejercicios

--Mi solucion
SELECT rpad('*', a, '*')
FROM generate_series(1, 16) AS s(a);
--Solucion del curso
SELECT lpad('*', CAST(ordinality AS int), '*')
FROM generate_series(10, 2, -2) WITH ordinality;




--Clase #14 "Regularizando expresiones"
SELECT email
FROM platzi.alumnos
WHERE email ~*'[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}';
--
SELECT email
FROM platzi.alumnos
WHERE email ~*'[A-Z0-9._%+-]+@google[A-Z0-9.-]+\.[A-Z]{2,4}';