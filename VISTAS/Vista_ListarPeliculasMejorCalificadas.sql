USE Rotten_DB;
GO

CREATE OR ALTER VIEW dbo.Vista_ListarPeliculasMejorCalificadas AS
SELECT TOP 100
    p.id_peliculas,
    p.titulo,
    CAST(AVG(CAST(c.puntuacion AS DECIMAL(3,2))) AS DECIMAL(3,2)) AS promedio_general,
    dbo.UFN_ObtenerEtiquetaPelicula(CAST(AVG(CAST(c.puntuacion AS DECIMAL(3,2))) AS DECIMAL(3,2))) AS etiqueta_reputacion,
    COUNT(c.id_usuario) AS cantidad_votos
FROM dbo.Peliculas p
INNER JOIN dbo.Calificaciones c ON p.id_peliculas = c.id_pelicula
GROUP BY p.id_peliculas, p.titulo
HAVING COUNT(c.id_usuario) >= 1
ORDER BY promedio_general DESC, cantidad_votos DESC;
GO