USE Rotten_DB;
GO


SELECT TOP 5 
    id_peliculas, 
    titulo, 
    genero, 
    pais_origen, 
    clasificacion_edad, 
    total_calificaciones
FROM dbo.Vista_DetallePeliculas;
GO