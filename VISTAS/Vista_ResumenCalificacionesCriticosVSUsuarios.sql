CREATE OR ALTER VIEW dbo.Vista_ResumenCalificacionesCriticosVSUsuarios AS
SELECT 
    p.id_peliculas,
    p.titulo,
    CAST(AVG(CASE WHEN u.tipo_usuario = 'Critico' THEN CAST(c.puntuacion AS DECIMAL(3,2)) END) AS DECIMAL(3,2)) AS promedio_criticos,
    COUNT(CASE WHEN u.tipo_usuario = 'Critico' THEN 1 END) AS votos_criticos,
    CAST(AVG(CASE WHEN u.tipo_usuario = 'Espectador' THEN CAST(c.puntuacion AS DECIMAL(3,2)) END) AS DECIMAL(3,2)) AS promedio_espectadores,
    COUNT(CASE WHEN u.tipo_usuario = 'Espectador' THEN 1 END) AS votos_espectadores
FROM dbo.Peliculas p
LEFT JOIN dbo.Calificaciones c ON p.id_peliculas = c.id_pelicula
LEFT JOIN dbo.Usuarios u ON c.id_usuario = u.id_usuarios
GROUP BY p.id_peliculas, p.titulo;
GO

