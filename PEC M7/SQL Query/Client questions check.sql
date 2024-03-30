use pec;

-- La evolución del volumen de tickets general y diferenciado por incidencias y peticiones
SELECT 
    YEAR(fi.fecha_creacion) AS Anio,
    MONTH(fi.fecha_creacion) AS Mes,
    SUM(CASE WHEN ts.tipo_servicio IN ('Restauración de infraestructura', 'Restauración de servicio a usuario',
    'Evento de infraestructura') THEN 1 ELSE 0 END) AS Num_Incidencias,
    SUM(CASE WHEN ts.tipo_servicio = 'Petición de serv. por el usuario' THEN 1 ELSE 0 END) AS Num_Peticiones,
    COUNT(*) AS Total_Tickets
FROM 
    f_incidencias fi
JOIN 
    d_torre_servicio dts ON fi.fk_torre_servicio = dts.id_torre_servicio
JOIN 
    d_servicio_tipo dst ON dts.fk_servicio_tipo = dst.id_servicio_tipo
JOIN
	d_tipo_servicio ts ON ts.id_tipo_servicio = dst.fk_tipo_servicio
GROUP BY 
    YEAR(fi.fecha_creacion), MONTH(fi.fecha_creacion)
ORDER BY 
    Anio, Mes;
    
-- Si ha variado la prioridad con la que se abren los tickets en los últimos meses (% de peso por prioridad)

SELECT 
    YEAR(fi.fecha_creacion) AS Anio,
    MONTH(fi.fecha_creacion) AS Mes,
    SUM(CASE WHEN dp.prioridad = 'Crítica' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS Porcentaje_Critica,
    SUM(CASE WHEN dp.prioridad = 'Alta' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS Porcentaje_Alta,
    SUM(CASE WHEN dp.prioridad = 'Media' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS Porcentaje_Media,
    SUM(CASE WHEN dp.prioridad = 'Baja' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS Porcentaje_Baja
FROM 
    f_incidencias fi
JOIN 
    d_prioridad dp ON fi.fk_prioridad = dp.id_prioridad
WHERE 
    fi.fecha_creacion >= DATE_SUB((SELECT MAX(fecha_creacion) FROM f_incidencias), INTERVAL 8 MONTH)
GROUP BY 
    YEAR(fi.fecha_creacion), MONTH(fi.fecha_creacion)
ORDER BY 
    Anio, Mes;

-- Cuáles son los servicios que acumulan más tickets y de ellos cuáles son los que menos cumplen los SLAs

WITH Servicios AS (
    SELECT 
        s.servicio,
        COUNT(*) AS total_tickets,
        SUM(CASE WHEN sla.sla = 'Dentro del objetivo de servicio' THEN 1 ELSE 0 END) AS tickets_cumplen_SLA
    FROM 
        f_incidencias fi
	JOIN
		d_torre_servicio dts ON fi.fk_torre_servicio = dts.id_torre_servicio
    JOIN 
        d_servicio_tipo dst ON dts.fk_servicio_tipo = dst.id_servicio_tipo
    JOIN 
        d_servicio s ON dst.fk_servicio = s.id_servicio
    JOIN 
        d_estado_sla des ON fi.fk_estado_sla = des.id_estado_sla
    JOIN 
        d_sla sla ON des.id_sla = sla.id_sla
    GROUP BY 
        s.servicio
)
SELECT 
    servicio,
    total_tickets,
    tickets_cumplen_SLA,
    (tickets_cumplen_SLA * 1.0 / total_tickets) AS porcentaje_cumplen_SLA
FROM 
    Servicios
ORDER BY 
    total_tickets DESC,
    porcentaje_cumplen_SLA ASC;

-- Cuáles son los servicios con más backlog acumulado (tickets abiertos en la actualidad)

SELECT 
    s.servicio,
    COUNT(*) AS backlog_acumulado
FROM 
    f_incidencias fi
JOIN
	d_torre_servicio dts ON fi.fk_torre_servicio = dts.id_torre_servicio
JOIN 
    d_servicio_tipo dst ON dst.id_servicio_tipo = dts.fk_servicio_tipo
JOIN 
    d_servicio s ON dst.fk_servicio = s.id_servicio
JOIN 
    d_estado_sla des ON fi.fk_estado_sla = des.id_estado_sla
JOIN 
    d_estado e ON des.id_estado = e.id_estado
WHERE 
    e.estado IN ('Pendiente', 'Asignado') -- Tickets en estado Pendiente o Asignado
GROUP BY 
    s.servicio
ORDER BY 
    backlog_acumulado DESC;

-- Cuáles son los servicios en que se resuelven más rápido y más lentos los tickets

SELECT 
    s.servicio,
    AVG(fi.duracion_dias) AS tiempo_promedio_resolucion
FROM 
    f_incidencias fi
JOIN
	d_torre_servicio dts ON fi.fk_torre_servicio = dts.id_torre_servicio
JOIN 
    d_servicio_tipo dst ON dst.id_servicio_tipo = dts.fk_servicio_tipo
JOIN 
    d_servicio s ON dst.fk_servicio = s.id_servicio
JOIN 
    d_estado_sla des ON fi.fk_estado_sla = des.id_estado_sla
JOIN 
    d_estado e ON des.id_estado = e.id_estado
WHERE 
    e.estado = 'Resuelto'-- Solo tickets resueltos
GROUP BY 
    s.servicio
ORDER BY 
    tiempo_promedio_resolucion;
    
SELECT 
    s.servicio,
    AVG(fi.duracion_dias) AS tiempo_promedio_resolucion
FROM 
    f_incidencias fi
JOIN
	d_torre_servicio dts ON fi.fk_torre_servicio = dts.id_torre_servicio
JOIN 
    d_servicio_tipo dst ON dst.id_servicio_tipo = dts.fk_servicio_tipo
JOIN 
    d_servicio s ON dst.fk_servicio = s.id_servicio
JOIN 
    d_estado_sla des ON fi.fk_estado_sla = des.id_estado_sla
JOIN 
    d_estado e ON des.id_estado = e.id_estado
WHERE 
    e.estado = 'Resuelto' -- Solo tickets resueltos
GROUP BY 
    s.servicio
ORDER BY 
    tiempo_promedio_resolucion DESC;


-- Volumetría de tickets en entornos productivos respecto a entornos no productivos

-- Posibilidad de filtrar por prioridad, por tipo de ticket y por servicio