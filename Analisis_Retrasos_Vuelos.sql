--Promedio en minutos de vuelos retrazados 
SELECT avg(arr_delay)
FROM flights
WHERE arr_delay > 0;

-- Cantidad de vuelos con demora > 32 por meses
SELECT month, count(flight) as Cantidad_vuelos
FROM flights  
WHERE arr_delay IS NOT NULL
AND  arr_time IS NOT NULL  
AND  sched_arr_time IS NOT NULL
aND arr_delay > 32
GROUP BY month
--HAVING arr_delay > avg(arr_delay)
ORDER BY Cantidad_vuelos DESC 
LIMIT 10000;


-- Cantidad de vuelos con demora > 32 por dias de la semana
SELECT 
DAYNAME(
    CONCAT(
        CAST(year AS STRING),"-"<
        LPAD(CAST(month AS STRING),2,"0"),"-",
        LPAD(CAST(day AS STRING),2,"0")
    )
) AS dia_semana,
COUNT(flight) AS cantidad

from flights 
wHERE arr_delay > 32
AND month = 7
-- AND month = 6
GROUP BY dia_semana
ORDER BY cantidad DESC

--Filtrando aeropuestos
SELECT 
origin,
dest,
COUNT(flight) AS cantidad
from flights
WHERE arr_delay > 32

GROUP BY origin,dest
ORDER BY cantidad DESC, dest


--ANALIZAR LOS AEROPUERTOS CON MAS RESTRAZOS por origen
SELECT
origin,
count(flight) AS cantidad
FROM flights
WHERE arr_delay > 32
GROUP BY origin
ORDER BY cantidad DESC

--ANALIZAR LOS AEROPUERTOS CON MAS RESTRAZOS por dest
SELECT
dest,
count(flight) AS cantidad
FROM flights
WHERE arr_delay > 32
GROUP BY dest
ORDER BY cantidad DESC


--ANALIZAR LOS AEROPUERTOS CON MAS RESTRAZOS por dest
SELECT
origin,dest,
count(flight) AS cantidad
FROM flights
WHERE arr_delay > 32
GROUP BY origin,dest
ORDER BY  cantidad DESC
LIMIT 500000


--Promedio cantidad de retrazos por origen
SELECT
avg(cantidad) AS promedio_cantidad_retrasos
FROM
(
    SELECT origin,
    count(flight) AS cantidad
    FROM flights
    WHERE arr_delay > 32
    GROUP BY origin
    ORDER BY  cantidad DESC
) AS subQuery


--Aeropuertos (origin) con cantidad retardos superior a 17975 
SELECT origin,
count(flight) AS cantidad
FROM flights
WHERE arr_delay > 32
GROUP BY origin
HAVING cantidad > 17975
ORDER BY  cantidad DESC

--Aeropuertos (dest) con cantidad retardos superior a 17975
SELECT dest,
count(flight) AS cantidad
FROM flights
WHERE arr_delay > 32
GROUP BY dest
HAVING cantidad > 17975
ORDER BY  cantidad DESC


--ANALIZAR LOS AEROPUERTOS CON MAS RESTRAZOS origin y dest
SELECT 
origin, dest,
count(flight) AS cantidad
FROM flights
WHERE arr_delay > 32
GROUP BY origin, dest
--HAVING cantidad > 17975
ORDER BY  cantidad DESC


-- analisis de aviones
SELECT tailnum,
count(flight) AS cantidad
FROM flights
WHERE arr_delay > 32
GROUP BY tailnum
ORDER BY cantidad DESC


-- Promedio de la cantidad de vuelos con retrasos por nave
SELECT
avg(cantidad)
FROM
(
    SELECT tailnum,
    count(flight) AS cantidad
    FROM flights
    WHERE arr_delay > 32
    GROUP BY tailnum
    ORDER BY cantidad DESC
) AS subQuery


-- Naves con numero de vuelos criticos
SELECT tailnum,
count(flight) AS cantidad
FROM flights
WHERE arr_delay > 32
GROUP BY tailnum
HAVING cantidad > 796
ORDER BY cantidad DESC

SELECT 
*
FROM
(
    SELECT 
    f2.origin, f2.tailnum,
    count(f2.flight) AS cantidad2
    FROM flights as f2
    WHERE arr_delay > 32
    GROUP BY f2.origin, f2.tailnum
    ORDER BY  cantidad2 DESC
) AS sb
INNER JOIN
(
SELECT f1.tailnum,
count(f1.flight) AS cantidad1
FROM flights as f1
WHERE arr_delay > 32
GROUP BY f1.tailnum
HAVING cantidad1 > 796
) as sbq 
ON sb.tailnum = sbq.tailnum



-- ------------------------------------

select tailnum, origin, arr_delay
from flights
where origin = "PDX" and tailnum = "N793JB" and arr_delay > 32

SELECT 
sb.origin, sb.tailnum, count(sb.cantidad2) as cant
FROM
(
    SELECT 
    f2.origin, f2.tailnum,
    count(f2.flight) AS cantidad2
    FROM flights as f2
    WHERE arr_delay > 32
    GROUP BY f2.origin, f2.tailnum
    ORDER BY  cantidad2 DESC
) AS sb
INNER JOIN
(
    SELECT f1.tailnum,
    count(f1.flight) AS cantidad1
    FROM flights as f1
    WHERE arr_delay > 32
    GROUP BY f1.tailnum
    HAVING cantidad1 > 796
) as sbq 
ON sb.tailnum = sbq.tailnum
group by sb.origin, sb.tailnum
ORDER BY cant desc

-- dest
SELECT 
sb.dest, sb.tailnum, count(sb.cantidad2) as cant
FROM
(
    SELECT 
    f2.dest, f2.tailnum,
    count(f2.flight) AS cantidad2
    FROM flights as f2
    WHERE arr_delay > 32
    GROUP BY f2.dest, f2.tailnum
    ORDER BY  cantidad2 DESC
) AS sb
INNER JOIN
(
    SELECT f1.tailnum,
    count(f1.flight) AS cantidad1
    FROM flights as f1
    WHERE arr_delay > 32
    GROUP BY f1.tailnum
    HAVING cantidad1 > 796
) as sbq 
ON sb.tailnum = sbq.tailnum
group by sb.dest, sb.tailnum
ORDER BY cant desc

-- ---------------------

SELECT
avg(lat)
FROM airports

SELECT
avg(lon)
FROM airports

SELECT
avg(alt)
FROM airports

-- ---

SELECT 
sb.faa, sb.lat
FROM
(
    SELECT
    air.faa, air.lat
    FROM airports as air
    WHERE lat > 41
    -- WHERE lat < 41
) AS sb
INNER JOIN
(
    SELECT dest,
    count(flight) AS cantidad
    FROM flights
    WHERE arr_delay > 32
    GROUP BY dest
    HAVING cantidad > 17975
    ORDER BY  cantidad DESC
) as sbq 
ON sb.faa = sbq.dest

-- ---

SELECT 
sb.faa, sb.lon
FROM
(
    SELECT
    air.faa, air.lon
    FROM airports as air
    WHERE lon > (-102)
) AS sb
INNER JOIN
(
    SELECT dest,
    count(flight) AS cantidad
    FROM flights
    WHERE arr_delay > 32
    GROUP BY dest
    HAVING cantidad > 17975
    ORDER BY  cantidad DESC
) as sbq 
ON sb.faa = sbq.dest