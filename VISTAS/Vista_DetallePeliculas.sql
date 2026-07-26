CREATE OR ALTER VIEW dbo.Vista_DetallePeliculas AS
SELECT 
    p.id_peliculas,
    p.titulo,
    p.sinopsis,
    p.duracion_minutos,
    p.fecha_estreno,
    g.nombre AS genero,
    pa.Nombre AS pais_origen,
    ce.nombre AS clasificacion_edad,
    COUNT(c.id_usuario) AS total_calificaciones
FROM dbo.Peliculas p
LEFT JOIN dbo.Genero g ON p.id_genero = g.id_genero
LEFT JOIN dbo.Pais pa ON p.pais_origen = pa.id_pais
LEFT JOIN dbo.Clasificacion_edad ce ON p.clasificacion_edad = ce.id_clasificacion
LEFT JOIN dbo.Calificaciones c ON p.id_peliculas = c.id_pelicula
GROUP BY 
    p.id_peliculas, p.titulo, p.sinopsis, p.duracion_minutos, 
    p.fecha_estreno, g.nombre, pa.Nombre, ce.nombre;
GO