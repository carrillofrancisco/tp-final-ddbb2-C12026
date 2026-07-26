USE Rotten_DB;
GO



SELECT TOP 10 
    id_peliculas, 
    titulo, 
    promedio_general, 
    etiqueta_reputacion, 
    cantidad_votos
FROM dbo.Vista_ListarPeliculasMejorCalificadas;
GO