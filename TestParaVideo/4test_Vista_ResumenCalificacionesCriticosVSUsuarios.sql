USE Rotten_DB;
GO



SELECT TOP 5 
    id_peliculas, 
    titulo, 
    promedio_criticos, 
    votos_criticos, 
    promedio_espectadores, 
    votos_espectadores
FROM dbo.Vista_ResumenCalificacionesCriticosVSUsuarios;
GO