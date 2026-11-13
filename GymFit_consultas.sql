USE GymFit;
GO

-- 1. JOIN: miembros con su membresia
SELECT m.nombre AS miembro, m.ciudad, ms.nombre AS membresia, ms.precio
FROM Miembro m
INNER JOIN Membresia ms ON m.id_membresia = ms.id_membresia;

-- 2. JOIN multiple + WHERE: inscripciones activas con miembro, clase y entrenador
SELECT m.nombre AS miembro, c.nombre AS clase, e.nombre AS entrenador, i.fecha
FROM Inscripcion i
INNER JOIN Miembro m    ON i.id_miembro = m.id_miembro
INNER JOIN Clase c      ON i.id_clase = c.id_clase
INNER JOIN Entrenador e ON c.id_entrenador = e.id_entrenador
WHERE i.estado = 'Activa'
ORDER BY i.fecha;

-- 3. LEFT JOIN + GROUP BY + COUNT: inscripciones por clase (incluye clases sin inscritos)
SELECT c.nombre AS clase, COUNT(i.id_inscripcion) AS total_inscripciones
FROM Clase c
LEFT JOIN Inscripcion i ON c.id_clase = i.id_clase
GROUP BY c.nombre
ORDER BY total_inscripciones DESC;

-- 4. GROUP BY + SUM / AVG / MIN / MAX: resumen por membresia
SELECT ms.nombre AS membresia,
       COUNT(m.id_miembro) AS cantidad_miembros,
       SUM(ms.precio)      AS ingresos_totales,
       AVG(ms.precio)      AS precio_promedio,
       MIN(m.fecha_ingreso) AS primer_ingreso,
       MAX(m.fecha_ingreso) AS ultimo_ingreso
FROM Membresia ms
INNER JOIN Miembro m ON ms.id_membresia = m.id_membresia
GROUP BY ms.nombre;

-- 5. GROUP BY + HAVING: miembros inscritos en mas de 1 clase
SELECT m.nombre AS miembro, COUNT(i.id_inscripcion) AS clases_inscritas
FROM Miembro m
INNER JOIN Inscripcion i ON m.id_miembro = i.id_miembro
GROUP BY m.nombre
HAVING COUNT(i.id_inscripcion) > 1
ORDER BY clases_inscritas DESC;

-- 6. SUBCONSULTA: miembros cuya membresia cuesta mas que el precio promedio
SELECT m.nombre AS miembro, ms.nombre AS membresia, ms.precio
FROM Miembro m
INNER JOIN Membresia ms ON m.id_membresia = ms.id_membresia
WHERE ms.precio > (SELECT AVG(precio) FROM Membresia);

-- 7. SUBCONSULTA: clases que no tienen ninguna inscripcion
SELECT nombre AS clase, horario, cupo
FROM Clase
WHERE id_clase NOT IN (SELECT id_clase FROM Inscripcion);

-- 8. GROUP BY + COUNT por ciudad con filtro WHERE
SELECT ciudad, COUNT(*) AS total_miembros
FROM Miembro
WHERE fecha_ingreso >= '2026-03-01'
GROUP BY ciudad
ORDER BY total_miembros DESC;
